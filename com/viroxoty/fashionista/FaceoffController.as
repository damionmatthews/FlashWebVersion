// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.FaceoffController

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.data.Look;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.ui.SnapshotController;
    import com.viroxoty.fashionista.data.Item;
    import flash.events.Event;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class FaceoffController {

        private static const LEFT_AVATAR_X:Number = 175;
        private static const LEFT_AVATAR_Y:Number = 65;
        private static const RIGHT_AVATAR_X:Number = 588;
        private static const RIGHT_AVATAR_Y:Number = 65;

        private static var _instance:FaceoffController;
        private static var first_faceoff_of_session:Boolean = true;

        private var faceoff_id:int;
        private var is_dummy:Boolean = false;
        private var first_look:Look;
        private var left_avatar:Look;
        private var right_avatar:Look;
        private var ui:MovieClip;
        private var left_avatar_mc:MovieClip;
        private var left_avatar_controller:AvatarController;
        private var right_avatar_mc:MovieClip;
        private var right_avatar_controller:AvatarController;
        private var counter:int = 0;
        private var user_won:Boolean = false;
        private var fresh_avatar_id:int = -1;

        public function FaceoffController(){
            this.left_avatar_controller = new AvatarController();
            this.right_avatar_controller = new AvatarController();
        }
        public static function getInstance():FaceoffController{
            if (_instance == null)
            {
                _instance = new (FaceoffController)();
            };
            return (_instance);
        }

        public function init_ui(_arg1:MovieClip):void{
            this.ui = _arg1;
            this.counter = 0;
            this.init_avatar_ui(this.ui.left_avatar_ui, "left");
            this.init_avatar_ui(this.ui.right_avatar_ui, "right");
            this.ui.left_look_btn.buttonMode = true;
            this.ui.left_look_btn.addEventListener(MouseEvent.CLICK, this.choose_left, false, 0, true);
            Util.setupButton(this.ui.left_look_btn);
            this.ui.right_look_btn.buttonMode = true;
            this.ui.right_look_btn.addEventListener(MouseEvent.CLICK, this.choose_right, false, 0, true);
            Util.setupButton(this.ui.right_look_btn);
            this.left_avatar_controller.mode = AvatarController.MODE_RUNWAY;
            this.left_avatar_controller.init();
            this.left_avatar_controller.get_avatar_mc_for({"set_avatar_mc":this.set_left_avatar_mc});
            this.left_avatar_controller.addEventListener(AvatarController.ITEMS_LOADED, this.left_avatar_ready);
            this.right_avatar_controller.mode = AvatarController.MODE_RUNWAY;
            this.right_avatar_controller.init();
            this.right_avatar_controller.get_avatar_mc_for({"set_avatar_mc":this.set_right_avatar_mc});
            this.right_avatar_controller.addEventListener(AvatarController.ITEMS_LOADED, this.right_avatar_ready);
        }
        public function destroy():void{
            this.left_avatar = null;
            this.right_avatar = null;
            this.left_avatar_mc = null;
            this.right_avatar_mc = null;
            this.left_avatar_controller.removeEventListener(AvatarController.ITEMS_LOADED, this.left_avatar_ready);
            this.right_avatar_controller.removeEventListener(AvatarController.ITEMS_LOADED, this.right_avatar_ready);
            this.faceoff_id = 0;
            this.user_won = false;
            this.ui = null;
            this.is_dummy = false;
            this.first_look = null;
        }
        public function show_ui():void{
            this.hide_judging_buttons();
            if (this.left_avatar)
            {
                this.ui.visible = true;
            };
            this.reset_avatar_ui(this.ui.left_avatar_ui);
            this.reset_avatar_ui(this.ui.right_avatar_ui);
            if (first_faceoff_of_session)
            {
                first_faceoff_of_session = false;
                if (UserData.getInstance().new_to_faceoff)
                {
                    Tracker.track(Tracker.VISIT, Tracker.FACEOFF);
                    Pop_Up.getInstance().display_popup(Pop_Up.FACEOFF_INTRO);
                };
            };
            this.ui.faceoff_choose_tip.visible = (((UserData.getInstance().first_faceoff_won == false)) && ((UserData.getInstance().last_avatar_id > 0)));
            if (((UserData.getInstance().first_time_visit()) && (UserData.getInstance().shopping_welcome)))
            {
                Runway.getInstance().runway.buy_tip.visible = false;
            };
        }
        public function hide_ui():void{
            if (this.left_avatar_mc)
            {
                this.left_avatar_mc.visible = false;
                this.left_avatar_mc.alpha = 0;
                this.reset_avatar(this.left_avatar_mc, this.left_avatar_controller);
                this.right_avatar_mc.visible = false;
                this.right_avatar_mc.alpha = 0;
                this.reset_avatar(this.right_avatar_mc, this.right_avatar_controller);
            };
            this.ui.visible = false;
        }
        public function just_entered_look(_arg1:int):void{
            this.fresh_avatar_id = _arg1;
        }
        public function get_faceoff():void{
            Tracer.out(("FaceoffController > get_faceoff : faceoff counter = " + this.counter));
            if (this.is_dummy)
            {
                this.get_dummy_faceoff_opponent();
                return;
            };
            if ((((this.counter == 0)) && ((this.fresh_avatar_id > 0))))
            {
                DataManager.getInstance().get_faceoff(this.faceoff_loaded, this.get_faceoff_fail, true);
            } else
            {
                DataManager.getInstance().get_faceoff(this.faceoff_loaded, this.get_faceoff_fail);
            };
        }
        public function faceoff_loaded(_arg1:Object):void{
            if (Runway.getInstance().mode != Runway.FACEOFF)
            {
                Tracer.out("faceoff_loaded > not on faceoff runway; bailing");
                return;
            };
            this.faceoff_id = _arg1.faceoffId;
            var _local2:Look = new Look();
            var _local3:Look = new Look();
            _local2.process_json(_arg1.avatars[0]);
            _local3.process_json(_arg1.avatars[1]);
            this.left_avatar = new Look();
            this.right_avatar = new Look();
            if ((((this.counter == 0)) && ((this.fresh_avatar_id > 0))))
            {
                this.fresh_avatar_id = -1;
                if (_local2.user_id == DataManager.user_id)
                {
                    this.right_avatar = _local2;
                    this.left_avatar = _local3;
                } else
                {
                    if (_local3.user_id == DataManager.user_id)
                    {
                        this.left_avatar = _local2;
                        this.right_avatar = _local3;
                    } else
                    {
                        Tracer.out("faceoff_loaded > ERROR: neither look belongs to the user");
                        DataManager.getInstance().send_alert("user look not in faceoff");
                    };
                };
            } else
            {
                this.left_avatar = _local2;
                this.right_avatar = _local3;
            };
            if ((((this.left_avatar.items.length == 0)) || ((this.right_avatar.items.length == 0))))
            {
                Tracer.out("faceoff_loaded > ERROR: one of the avatars has 0 items; loading the next faceoff");
                this.get_faceoff();
                return;
            };
            this.ui.visible = true;
            MainViewController.getInstance().show_preloader();
            this.load_faceoff_look(this.left_avatar, true);
            this.load_faceoff_look(this.right_avatar, false);
            this.counter++;
        }
        public function get_faceoff_fail():void{
            MainViewController.getInstance().hide_preloader();
            Pop_Up.getInstance().alert("No Faceoffs to view at this time!");
        }
        public function just_entered_first_look(_arg1:Look):void{
            Tracer.out(("FaceoffController > just_entered_first_look for " + _arg1.name));
            this.is_dummy = true;
            this.first_look = _arg1;
        }
        function get_dummy_faceoff_opponent():void{
            DataManager.getInstance().get_dummy_faceoff_opponent(this.dummy_faceoff_opponent_loaded, this.dummy_faceoff_opponent_fail);
        }
        public function dummy_faceoff_opponent_loaded(_arg1:Object):void{
            this.left_avatar = new Look();
            this.left_avatar.process_json(_arg1);
            this.right_avatar = this.first_look;
            this.ui.visible = true;
            this.ui.faceoff_choose_tip.visible = true;
            MainViewController.getInstance().show_preloader();
            this.load_faceoff_look(this.left_avatar, true);
            this.load_faceoff_look(this.right_avatar, false);
        }
        public function dummy_faceoff_opponent_fail():void{
            PopupIntro.getInstance().display_popup(PopupIntro.FACEOFF_SHOPPING_TIP, true);
            Pop_Up.getInstance().alert("No Faceoffs to view at this time!");
        }
        public function faceoff_judged():void{
            Tracer.out(((("faceoff_judged : user_won = " + this.user_won) + ", first_faceoff_won = ") + UserData.getInstance().first_faceoff_won));
            if (((this.user_won) && ((UserData.getInstance().first_faceoff_won == false))))
            {
                Tracer.out("user won first faceoff");
                UserData.getInstance().first_faceoff_won = true;
                Tracker.track(Tracker.WIN, Tracker.FACEOFF);
                Pop_Up.getInstance().display_popup(Pop_Up.FIRST_FACEOFF_WIN);
            } else
            {
                this.get_faceoff();
            };
            this.user_won = false;
            if (UserData.getInstance().shopping_welcome)
            {
                PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
            };
        }
        public function set_left_avatar_mc(_arg1:MovieClip):void{
            Tracer.out("Faceoff > set_left_avatar_mc");
            this.left_avatar_mc = _arg1;
            this.left_avatar_mc.x = LEFT_AVATAR_X;
            this.left_avatar_mc.y = LEFT_AVATAR_Y;
            this.left_avatar_mc.visible = false;
            this.left_avatar_mc.alpha = 0;
            this.ui.addChildAt(this.left_avatar_mc, 0);
        }
        public function set_right_avatar_mc(_arg1:MovieClip):void{
            Tracer.out("Faceoff > set_right_avatar_mc");
            this.right_avatar_mc = _arg1;
            this.right_avatar_mc.x = RIGHT_AVATAR_X;
            this.right_avatar_mc.scaleX = -1;
            this.right_avatar_mc.y = RIGHT_AVATAR_Y;
            this.right_avatar_mc.visible = false;
            this.right_avatar_mc.alpha = 0;
            this.ui.addChildAt(this.right_avatar_mc, 0);
        }
        public function update_a_list_btns():void{
            this.update_a_list_btn(true);
            this.update_a_list_btn(false);
        }
        public function update_a_list_btn(_arg1:Boolean):void{
            MainViewController.getInstance().hide_preloader();
            var _local2:MovieClip = ((_arg1) ? this.ui.left_avatar_ui.a_list_btn : this.ui.right_avatar_ui.a_list_btn);
            var _local3:String = ((_arg1) ? this.left_avatar.user_id : this.right_avatar.user_id);
            Tracer.out(("update_a_list_btn > uid is " + _local3));
            if (_local3 == DataManager.user_id)
            {
                _local2.visible = false;
                return;
            };
            _local2.visible = true;
            if (UserData.getInstance().check_a_list(_local3))
            {
                Tracer.out("already on A-List");
                _local2.gotoAndStop(2);
            } else
            {
                Tracer.out("not on A-List");
                _local2.gotoAndStop(1);
            };
        }
        function choose_left(_arg1:MouseEvent):void{
            this.hide_judging_buttons();
            this.fade_out_avatar(this.right_avatar_mc, this.right_avatar_controller);
            this.judge_faceoff(this.left_avatar);
        }
        function choose_right(_arg1:MouseEvent):void{
            this.hide_judging_buttons();
            this.fade_out_avatar(this.left_avatar_mc, this.left_avatar_controller);
            this.judge_faceoff(this.right_avatar);
        }
        function judge_faceoff(_arg1:Look):void{
            Tracer.out(("judge_faceoff with winning id " + _arg1.id));
            this.ui.faceoff_choose_tip.visible = false;
            this.user_won = (_arg1.user_id == DataManager.user_id);
            if (this.user_won)
            {
                UserData.getInstance().pending_fcash_reward = Constants.FACEOFF_REWARD;
                UserData.getInstance().pending_points_reward = Constants.FACEOFF_REWARD;
            };
            if (this.is_dummy)
            {
                DataManager.getInstance().judge_dummy_faceoff(this.left_avatar.user_id, this.left_avatar.id, (_arg1 == this.left_avatar));
                PopupIntro.getInstance().display_popup(PopupIntro.FACEOFF_SHOPPING_TIP, this.user_won);
                if (this.user_won)
                {
                    UserData.getInstance().first_faceoff_won = true;
                };
            } else
            {
                DataManager.getInstance().judge_faceoff(this.faceoff_id, _arg1.id, this.faceoff_judged);
            };
        }
        function hide_judging_buttons():void{
            this.left_avatar_mc.ready = false;
            this.right_avatar_mc.ready = false;
            this.ui.left_look_btn.gotoAndStop(1);
            this.ui.left_look_btn.mouseEnabled = false;
            this.ui.left_look_btn.mouseChildren = false;
            this.ui.right_look_btn.gotoAndStop(1);
            this.ui.right_look_btn.mouseEnabled = false;
            this.ui.right_look_btn.mouseChildren = false;
            this.ui.left_avatar_ui.mouseEnabled = false;
            this.ui.left_avatar_ui.mouseChildren = false;
            this.ui.right_avatar_ui.mouseEnabled = false;
            this.ui.right_avatar_ui.mouseChildren = false;
        }
        function show_judging_buttons():void{
            this.ui.left_look_btn.mouseEnabled = true;
            this.ui.left_look_btn.mouseChildren = true;
            Tracer.out(("hittesting left_look_btn: " + this.ui.left_look_btn.hitTestPoint(this.ui.stage.mouseX, this.ui.stage.mouseY)));
            if (this.ui.left_look_btn.hitTestPoint(this.ui.stage.mouseX, this.ui.stage.mouseY))
            {
                this.ui.left_look_btn.gotoAndStop(2);
            };
            this.ui.right_look_btn.mouseEnabled = true;
            this.ui.right_look_btn.mouseChildren = true;
            Tracer.out(("hittesting right_look_btn: " + this.ui.left_look_btn.hitTestPoint(this.ui.stage.mouseX, this.ui.stage.mouseY)));
            if (this.ui.right_look_btn.hitTestPoint(this.ui.stage.mouseX, this.ui.stage.mouseY))
            {
                this.ui.right_look_btn.gotoAndStop(2);
            };
            this.ui.left_avatar_ui.mouseEnabled = true;
            this.ui.left_avatar_ui.mouseChildren = true;
            this.ui.right_avatar_ui.mouseEnabled = true;
            this.ui.right_avatar_ui.mouseChildren = true;
        }
        function init_avatar_ui(_arg1:MovieClip, _arg2:String):void{
            _arg1.side = _arg2;
            Util.simpleButton(_arg1.photo_btn, this.take_snapshot);
            _arg1.name_btn.buttonMode = true;
            _arg1.name_btn.addEventListener(MouseEvent.CLICK, this.show_profile, false, 0, true);
            Util.create_tooltip("ADD AS FRIEND!", this.ui, _arg2, "bottom", _arg1.name_btn);
            _arg1.team_icon.buttonMode = true;
            _arg1.team_icon.addEventListener(MouseEvent.CLICK, this.open_team, false, 0, true);
            _arg1.a_list_btn.stop();
            _arg1.a_list_btn.buttonMode = true;
            _arg1.a_list_btn.addEventListener(MouseEvent.CLICK, this.click_a_list, false, 0, true);
            _arg1.visit_btn.buttonMode = true;
            _arg1.visit_btn.addEventListener(MouseEvent.CLICK, this.visit_boutique, false, 0, true);
        }
        function reset_avatar_ui(_arg1:MovieClip):void{
            _arg1.team_icon.visible = false;
            while (_arg1.team_icon.pic.numChildren > 0)
            {
                _arg1.team_icon.pic.removeChildAt(0);
            };
            _arg1.name_txt.text = "";
        }
        function ui_clicked(_arg1:MouseEvent):String{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            return (MovieClip(_local2.parent).side);
        }
        function get_look_for_side(_arg1:MouseEvent):Look{
            var _local2:Look = this[(this.ui_clicked(_arg1) + "_avatar")];
            return (_local2);
        }
        function take_snapshot(_arg1:MouseEvent):void{
            Util.stopClip(Runway.getInstance().runway.bg);
            var _local2:String = this.ui_clicked(_arg1);
            var _local3:SnapshotController = SnapshotController.getInstance();
            _local3.show_with_avatar(this[(_local2 + "_avatar_mc")], this[(_local2 + "_avatar_controller")]);
        }
        private function show_profile(_arg1:MouseEvent):void{
            var _local2:Look = this.get_look_for_side(_arg1);
            Util.open_url(_local2.profile_url);
        }
        private function open_team(_arg1:MouseEvent):void{
            MessageCenter.getInstance().show_team();
        }
        private function click_a_list(_arg1:MouseEvent):void{
            if (MovieClip(_arg1.currentTarget).currentFrame == 1)
            {
                this.add_a_list(_arg1);
            } else
            {
                this.remove_a_list(_arg1);
            };
        }
        private function add_a_list(_arg1:MouseEvent):void{
            var _local2:Look = this.get_look_for_side(_arg1);
            var _local3:String = _local2.user_id;
            Tracer.out((("add uid " + _local3) + " to user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().add_to_a_list(_local3, _local2.name, this.update_a_list_btns, this.update_a_list_btns);
        }
        private function remove_a_list(_arg1):void{
            var _local2:Look = this.get_look_for_side(_arg1);
            var _local3:String = _local2.user_id;
            Tracer.out((("remove uid " + _local3) + " from user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().remove_from_a_list(_local3, this.update_a_list_btns, this.update_a_list_btns);
        }
        private function visit_boutique(_arg1:MouseEvent):void{
            var _local2:Look = this.get_look_for_side(_arg1);
            var _local3:String = _local2.user_id;
            Tracer.out(("TODO: visit boutique for uid " + _local3));
            BoutiqueVisit.createVisit(_local3, _local2.name);
        }
        private function load_faceoff_look(look:Look, isLeft:Boolean):void{
            var avatar_mc:MovieClip;
            var avatar_controller:AvatarController;
            var fade_out_and_setup:* = undefined;
            var setup_avatar:* = function ():void{
                var _local3:Item;
                avatar_controller.set_styles(look.styles);
                var _local1:int = look.items.length;
                var _local2:int;
                while (_local2 < _local1)
                {
                    _local3 = look.items[_local2];
                    if ((((look.user_id == DataManager.user_id)) || (((UserData.getInstance().first_time_visit()) && (UserData.getInstance().shopping_welcome)))))
                    {
                        _local3.name = "";
                        _local3.description = "";
                        _local3.price = -1;
                        _local3.level = -1;
                    };
                    avatar_controller.display_contestant_item(_local3, _local1);
                    _local2++;
                };
            };
            if (look.items.length == 0)
            {
                Tracer.out(("FaceoffController > load_contestant_avatar:  ERROR: no items for this look! > " + look.toString()));
                Tracker.track(("avatar_id_" + look.id), "no_item_avatar");
            };
            Tracer.out(("look is " + look.toString()));
            avatar_mc = ((isLeft) ? this.left_avatar_mc : this.right_avatar_mc);
            avatar_mc.visible = true;
            Tracer.out(("load_faceoff_avatar > avatar_mc.alpha = " + avatar_mc.alpha));
            var avatar_ui:MovieClip = ((isLeft) ? this.ui.left_avatar_ui : this.ui.right_avatar_ui);
            avatar_ui.name_txt.text = look.name;
            avatar_ui.team_icon.visible = false;
            avatar_ui.visit_btn.visible = ((!((look.user_id == DataManager.user_id))) && (look.activeBoutique));
            this.update_a_list_btn(isLeft);
            avatar_ui.visible = true;
            avatar_controller = ((isLeft) ? this.left_avatar_controller : this.right_avatar_controller);
            avatar_controller.reset_item_counter();
            if (avatar_mc.alpha > 0)
            {
                fade_out_and_setup = function (_arg1:Event):void{
                    _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha - 0.3);
                    if (_arg1.currentTarget.alpha <= 0)
                    {
                        _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, fade_out_and_setup);
                        _arg1.currentTarget.alpha = 0;
                        reset_avatar(avatar_mc, avatar_controller);
                        setup_avatar();
                    };
                };
                avatar_mc.addEventListener(Event.ENTER_FRAME, fade_out_and_setup);
            } else
            {
                (setup_avatar());
            };
            MainViewController.getInstance().show_preloader();
        }
        function left_avatar_ready(_arg1:Event):void{
            this.left_avatar_mc.ready = true;
            this.check_avatars_ready();
        }
        function right_avatar_ready(_arg1:Event):void{
            this.right_avatar_mc.ready = true;
            this.check_avatars_ready();
        }
        function check_avatars_ready():void{
            Tracer.out("FaceoffController > check_avatars_ready");
            if (((this.left_avatar_mc.ready) && (this.right_avatar_mc.ready)))
            {
                Tracer.out("FaceoffController > both avatars ready");
                this.show_judging_buttons();
                MainViewController.getInstance().hide_preloader();
                this.fade_in_avatar(this.left_avatar_mc);
                this.fade_in_avatar(this.right_avatar_mc);
            };
        }
        function reset_avatar(_arg1:MovieClip, _arg2:AvatarController):void{
            if (_arg1 == null)
            {
                return;
            };
            _arg2.remove_all();
        }
        function fade_out_avatar(avatar_mc:MovieClip, avatar_controller:AvatarController):void{
            var fade_out:* = undefined;
            fade_out = function (_arg1:Event):void{
                _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha - 0.3);
                if (_arg1.currentTarget.alpha <= 0)
                {
                    _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, fade_out);
                    _arg1.currentTarget.alpha = 0;
                    reset_avatar(avatar_mc, avatar_controller);
                };
            };
            avatar_mc.addEventListener(Event.ENTER_FRAME, fade_out);
        }
        function fade_in_avatar(avatar_mc:MovieClip):void{
            var fade_in:* = undefined;
            fade_in = function (_arg1:Event):void{
                _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha + 0.3);
                if (_arg1.currentTarget.alpha >= 1)
                {
                    _arg1.currentTarget.alpha = 1;
                    _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, fade_in);
                };
            };
            avatar_mc.addEventListener(Event.ENTER_FRAME, fade_in);
        }

    }
}//package com.viroxoty.fashionista

