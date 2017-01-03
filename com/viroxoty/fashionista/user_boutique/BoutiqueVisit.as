// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.BoutiqueVisit

package com.viroxoty.fashionista.user_boutique{
    import com.viroxoty.fashionista.data.UserDecor;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import com.viroxoty.fashionista.data.UserBoutique;
    import com.viroxoty.fashionista.data.Decor;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.display.BitmapData;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;
    import flash.external.*;

    public class BoutiqueVisit extends UserBoutiqueController {

        private static var _instance:BoutiqueVisit;
        static var HEART_TIP_Y_ADJ:int = -62;

        public var user_id:String;
        var username:String;
        var floor:UserDecor;
        var wall:UserDecor;
        var models:Vector.<UserBoutiqueModel>;
        var wallContainer:MovieClip;
        var mirrorContainer:MovieClip;
        var floorContainer:MovieClip;
        var rugContainer:MovieClip;
        var decorContainer:MovieClip;
        var lightsContainer:MovieClip;
        var modelContainer:Sprite;
        var modelViewControllers:Vector.<UserBoutiqueModelViewController>;
        var total_assets:int;
        var loaded_assets:int;
        var glowFilter:GlowFilter;

        public function BoutiqueVisit(){
            this.glowFilter = new GlowFilter(0xFFFFFF, 0.6, 6, 6, 2, 1);
        }
        public static function getInstance():BoutiqueVisit{
            return (_instance);
        }
        public static function createVisit(_arg1:String, _arg2:String):void{
            _instance = new (BoutiqueVisit)();
            _instance.user_id = _arg1;
            _instance.username = _arg2;
            _instance.load();
        }

        public function load(){
            Tracer.out("loading user_boutique swf");
            Main.getInstance().set_section(Constants.SECTION_BOUTIQUE_VISIT);
            MainViewController.getInstance().load_asset(Constants.USER_BOUTIQUE_FILENAME, this.loaded_boutique);
        }
        public function loaded_boutique(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("BoutiqueVisit > loaded_boutique");
            view = _arg1;
            MainViewController.getInstance().swap_swf(view);
        }
        override public function init():void{
            Tracer.out("BoutiqueVisit > init");
            DataManager.getInstance().visit_user_boutique(this.user_id, this.got_user_boutique, this.get_boutique_fail);
            super.init();
            view.star_btn.visible = false;
            
			view.heart_btn.y = (view.heart_btn.y + HEART_TIP_Y_ADJ);
            view.tip_heart.y = (view.tip_heart.y + HEART_TIP_Y_ADJ);
			view.heart_btn.visible=false;
			view.tip_heart.visible=false;
            
			view.decorate_btn.visible = false;
            view.floor_tip.y = (view.floor_tip.y + 22);
            this.wallContainer = view.wallContainer;
            this.mirrorContainer = view.mirrorContainer;
            this.floorContainer = view.floorContainer;
            this.rugContainer = view.rugContainer;
            this.decorContainer = view.decorContainer;
            this.lightsContainer = view.lightsContainer;
            this.modelContainer = new Sprite();
            view.addChildAt(this.modelContainer, (view.getChildIndex(this.lightsContainer) + 1));
            view.model_ui.visible = false;
            view.a_list_btn.visible = false;
            Util.simpleButton(view.a_list_btn, this.click_a_list);
            view.befriend_btn.visible = false;
            Util.simpleButton(view.befriend_btn, this.click_befriend);
            Util.simpleRolloverTip(view.befriend_btn, view.tip_befriend);
            Util.simpleButton(view.photo_btn, this.take_photo);
            var _local1:MovieClip = view.floor_ui;
            _local1.up_btn.buttonMode = true;
            _local1.up_btn.addEventListener(MouseEvent.CLICK, this.next_floor, false, 0, true);
            _local1.up_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_floor_tip, false, 0, true);
            _local1.up_btn.addEventListener(MouseEvent.ROLL_OUT, hide_floor_tip, false, 0, true);
            _local1.down_btn.buttonMode = true;
            _local1.down_btn.addEventListener(MouseEvent.CLICK, this.prev_floor, false, 0, true);
            _local1.down_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_floor_tip, false, 0, true);
            _local1.down_btn.addEventListener(MouseEvent.ROLL_OUT, hide_floor_tip, false, 0, true);
            /*if (UserData.getInstance().show_like_button)
            {
                view.heart_btn.buttonMode = true;
                view.heart_btn.addEventListener(MouseEvent.CLICK, this.show_like_popup, false, 0, true);
                view.heart_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_heart_glow, false, 0, true);
                view.heart_btn.addEventListener(MouseEvent.ROLL_OUT, this.hide_heart_glow, false, 0, true);
                view.heart_btn.glow.visible = false;
                if (UserData.getInstance().visits == 3)
                {
                    view.tip_heart.visible = true;
                };
            } else
            {
                view.heart_btn.visible = false;
            };*/
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.init_like_btn, false, 0, true);
            Pop_Up.getInstance().addEventListener(Pop_Up.POPUP_OPENED, this.hide_like_btn, false, 0, true);
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.init_like_btn, false, 0, true);
            MainViewController.getInstance().addEventListener(MainViewController.OPENED_MESSAGE_CENTER, this.hide_like_btn, false, 0, true);
        }
        public function destroy():void{
            Tracer.out("BoutiqueVisit > destroy");
            boutique = null;
            directory_controller.destroy();
            ExternalInterface.call("fashionista.external.showLikeButton", false);
            Pop_Up.getInstance().removeEventListener(Pop_Up.POPUP_OPENED, this.hide_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.init_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.OPENED_MESSAGE_CENTER, this.hide_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.init_like_btn);
            CleanupController.remove_mess();
        }
        public function enter_boutique():void{
            if (CleanupController.check_cleanup(boutique))
            {
                CleanupController.create_mess(boutique);
            } else
            {
                Notification.getInstance().add_notification(Notification.MY_BOUTIQUE_VISIT_WELCOME, this.username);
            };
            if (boutique.visited == false)
            {
                DataManager.getInstance().earn_experience(Constants.XP_CODE_FIRST_USER_BOUTIQUE_VISIT, Constants.FIRST_USER_BOUTIQUE_VISIT_REWARD);
            };
        }
        public function hide_like_btn(_arg1=null){
            External.hideLikeButton();
        }
        public function init_like_btn(_arg1=null){
            if (MainViewController.getInstance().inMessageCenter())
            {
                return;
            };
            var _local2:String = ((((Constants.FACEBOOK_APP_PAGE + "/index.php?boutique_owner=") + this.user_id) + "&level=") + current_floor);
            External.initLikeButton("boutiqueLevel", _local2);
            this.show_like_btn();
        }
        public function show_like_btn(){
            External.showLikeButton();
        }
        public function hide_heart_btn(){
            view.heart_btn.visible = false;
            view.tip_heart.visible = false;
        }
        function got_user_boutique(_arg1:UserBoutique){
            boutique = _arg1;
            boutique.username = this.username;
            if (boutique.firstVisitAnyBoutique)
            {
                PopupIntro.getInstance().display_popup(PopupIntro.BOUTIQUE_VISIT_TIP, this.enter_boutique);
            } else
            {
                this.enter_boutique();
            };
            current_floor = boutique.entry_floor;
            this.show_current_floor();
            view.floor_ui.up_btn.visible = (current_floor < boutique.floorCount);
            view.floor_ui.down_btn.visible = (current_floor > 1);
            directory_controller.set_current_user_boutique(boutique);
            directory_controller.init_with_view(view.directory);
            view.directory.visible = true;
            this.update_a_list_btn(false);
            view.a_list_btn.visible = true;
            view.befriend_btn.visible = true;
            Util.fadeOut(view.preloader);
        }
        function get_boutique_fail(){
            Tracer.out("get_boutique_fail");
        }
        function load_boutique_floor(_arg1:int){
            DataManager.getInstance().load_user_boutique_floor(this.user_id, _arg1, boutique, this.loaded_boutique_floor, this.load_boutique_floor_fail);
        }
        function loaded_boutique_floor(){
            this.show_current_floor();
        }
        function load_boutique_floor_fail(){
            Tracer.out("load_boutique_floor_fail");
        }
        public function show_current_floor(){
            var init_controller:Function;
            var setup_avatar:Function;
            var userDecor:UserDecor;
            var decor:Decor;
            var dvc:DecorViewController;
            var i:int;
            init_controller = function (_arg1:UserBoutiqueModel, _arg2:int, _arg3:Vector.<UserBoutiqueModel>){
                if (_arg1.placed == false)
                {
                    return;
                };
                var _local4:UserBoutiqueModelViewController = new UserBoutiqueModelViewController(_arg1);
                _local4.addEventListener(UserBoutiqueModelViewController.AVATAR_READY, setup_avatar, false, 0, true);
                _local4.init_avatar(AvatarController.MODE_RUNWAY);
                modelViewControllers.push(_local4);
            };
            setup_avatar = function (_arg1:Event){
                var _local2:UserBoutiqueModelViewController = (_arg1.currentTarget as UserBoutiqueModelViewController);
                _local2.avatar_controller.display_with_items(_local2.data.items);
            };
            if (boutique.floor_loaded(current_floor) == false)
            {
                this.load_boutique_floor(current_floor);
                return;
            };
            this.clear_floor();
            DataManager.getInstance().visit_my_boutique_level(boutique.user_id, current_floor, this.visit_level_return);
            view.floor_ui.floor_txt.text = String(current_floor);
            var decor_data:Array = boutique.get_decor_for_floor(current_floor);
            this.total_assets = decor_data.length;
            Tracer.out((((("BoutiqueVisit > show_current_floor : floor " + current_floor) + " has ") + this.total_assets) + " decors"));
            this.loaded_assets = 0;
            if (this.total_assets > 0)
            {
                MainViewController.getInstance().show_preloader();
            };
            while (i < this.total_assets)
            {
                userDecor = decor_data[i];
                this.load_user_decor(userDecor);
                i = (i + 1);
            };
            Tracer.out(((("BoutiqueVisit > show_current_floor: wall = " + this.wall) + ", floor = ") + this.floor));
            if (current_floor == 1)
            {
                if (this.wall == null)
                {
                    decor = Decor.getDefaultWall();
                    userDecor = decor.newInstance();
                    dvc = new DecorViewController(userDecor);
                    dvc.loadAsset();
                    this.wallContainer.addChild(dvc);
                };
                if (this.floor == null)
                {
                    decor = Decor.getDefaultFloor();
                    userDecor = decor.newInstance();
                    dvc = new DecorViewController(userDecor);
                    dvc.loadAsset();
                    this.floorContainer.addChild(dvc);
                };
            };
            this.init_like_btn();
            this.models = boutique.get_models_for_floor(current_floor);
            Tracer.out(("BoutiqueVisit > show_current_floor: number of models is " + this.models.length));
            this.modelViewControllers = new Vector.<UserBoutiqueModelViewController>();
            this.models.forEach(init_controller);
            this.add_models();
        }
        public function visit_level_return(_arg1:int):void{
            view.visits_ui.all_visits_txt.text = String(_arg1);
        }
        function load_user_decor(_arg1:UserDecor):DecorViewController{
            var _local2:DecorViewController = new DecorViewController(_arg1);
            this.add_decor_to_container(_local2);
            _local2.addEventListener(DecorManager.EVENT_DECOR_LOADED, this.decor_asset_loaded, false, 0, true);
            _local2.loadAsset();
            if (_arg1.decor.category == "walls")
            {
                this.wall = _arg1;
            } else
            {
                if (_arg1.decor.category == "floors")
                {
                    this.floor = _arg1;
                };
            };
            return (_local2);
        }
        function decor_asset_loaded(_arg1:Event){
            var _local2:DecorViewController = (_arg1.currentTarget as DecorViewController);
            Tracer.out(((("decor_asset_loaded : " + _local2.data.decor.name) + ", category is ") + _local2.data.decor.category));
            this.loaded_assets++;
            if (this.loaded_assets == this.total_assets)
            {
                MainViewController.getInstance().hide_preloader();
            };
        }
        function add_decor_to_container(_arg1:DecorViewController){
            var _local2:int;
            var _local3:String = _arg1.data.decor.category;
            switch (_local3)
            {
                case "floors":
                    this.floorContainer.addChild(_arg1);
                    break;
                case "walls":
                    this.wallContainer.addChild(_arg1);
                    break;
                case "mirrors":
                    _local2 = Math.min(_arg1.data.z_pos, this.mirrorContainer.numChildren);
                    this.mirrorContainer.addChildAt(_arg1, _local2);
                    break;
                case "rugs":
                    _local2 = Math.min(_arg1.data.z_pos, this.rugContainer.numChildren);
                    this.rugContainer.addChildAt(_arg1, _local2);
                    break;
                case "lights":
                    _local2 = Math.min(_arg1.data.z_pos, this.lightsContainer.numChildren);
                    this.lightsContainer.addChildAt(_arg1, _local2);
                    break;
                default:
                    _local2 = Math.min(_arg1.data.z_pos, this.decorContainer.numChildren);
                    this.decorContainer.addChildAt(_arg1, _local2);
            };
            _arg1.addEventListener(MouseEvent.MOUSE_DOWN, this.buy_decor, false, 0, true);
            if (_arg1.data.decor.isWallFloor == false)
            {
                _arg1.addEventListener(MouseEvent.ROLL_OVER, this.roll_over_decor, false, 0, true);
                _arg1.addEventListener(MouseEvent.ROLL_OUT, this.roll_out_decor, false, 0, true);
            };
        }
        function roll_over_decor(_arg1:MouseEvent):void{
            var _local2:DecorViewController = (_arg1.currentTarget as DecorViewController);
            _local2.filters = [this.glowFilter];
        }
        function roll_out_decor(_arg1:MouseEvent):void{
            var _local2:DecorViewController = (_arg1.currentTarget as DecorViewController);
            _local2.filters = [];
        }
        function clear_floor(){
            this.floor = null;
            this.wall = null;
            this.total_assets = 0;
            this.loaded_assets = 0;
            this.clear_container(this.decorContainer);
            this.clear_container(this.rugContainer);
            this.clear_container(this.mirrorContainer);
            this.clear_container(this.lightsContainer);
            this.clear_container(this.floorContainer);
            this.clear_container(this.wallContainer);
            this.clear_container(this.modelContainer);
        }
        function clear_container(_arg1:DisplayObjectContainer){
            while (_arg1.numChildren > 0)
            {
                _arg1.removeChildAt(0);
            };
        }
        function next_floor(_arg1:MouseEvent=null){
            current_floor++;
            view.floor_ui.down_btn.visible = true;
            view.floor_ui.up_btn.visible = (current_floor < boutique.floorCount);
            if (view.floor_tip.visible)
            {
                this.show_floor_tip();
            };
            this.show_current_floor();
        }
        function prev_floor(_arg1:MouseEvent=null){
            current_floor--;
            view.floor_ui.up_btn.visible = true;
            view.floor_ui.down_btn.visible = (current_floor > 1);
            this.show_current_floor();
        }
        function show_floor_tip(_arg1:MouseEvent=null){
            var _local2:String;
            if (((_arg1) && ((_arg1.currentTarget == view.floor_ui.down_btn))))
            {
                _local2 = "Go Down a Level";
            } else
            {
                _local2 = "Go Up a Level";
            };
            view.floor_tip.tip_txt.text = _local2;
            view.floor_tip.visible = true;
        }
        function buy_decor(_arg1=null){
            var _local2:DecorViewController = (_arg1.currentTarget as DecorViewController);
            UserData.getInstance().buy_decor(_local2.data.decor);
        }
        public function update_a_list_btn(_arg1:Boolean=true):void{
            MainViewController.getInstance().hide_preloader();
            var _local2:MovieClip = view.a_list_btn;
            if (UserData.getInstance().check_a_list(this.user_id))
            {
                Tracer.out("already on A-List");
                _local2.gotoAndStop(2);
            } else
            {
                Tracer.out("not on A-List");
                _local2.gotoAndStop(1);
            };
            if (_arg1)
            {
                directory_controller.update_a_list();
            };
        }
        function click_a_list(_arg1:MouseEvent):void{
            if (MovieClip(_arg1.currentTarget).currentFrame == 1)
            {
                this.add_a_list();
            } else
            {
                this.remove_a_list();
            };
        }
        function add_a_list():void{
            Tracer.out((("add user_id " + this.user_id) + " to user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().add_to_a_list(this.user_id, this.username, this.update_a_list_btn, this.update_a_list_btn);
        }
        private function remove_a_list():void{
            Tracer.out((("remove user_id " + this.user_id) + " from user's A-List"));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().remove_from_a_list(this.user_id, this.update_a_list_btn, this.update_a_list_btn);
        }
        function click_befriend(_arg1:MouseEvent):void{
            FacebookConnector.open_profile(this.user_id);
        }
        function show_heart_glow(_arg1=null){
            //view.heart_btn.glow.visible = true;
        }
        function hide_heart_glow(_arg1=null){
            //view.heart_btn.glow.visible = false;
        }
        function show_like_popup(_arg1=null){
            Pop_Up.getInstance().display_popup(Pop_Up.LIKE_FASHIONISTA);
        }
        function make_star(_arg1=null):void{
            Pop_Up.getInstance().display_popup(Pop_Up.MAKE_ME_A_STAR);
        }
        public function take_photo(_arg1=null):void{
            var _local2:String = ((("Check out this great boutique by " + this.username) + " in Fashionista FaceOff!  ") + Util.url_with_http(Constants.FACEBOOK_APP_PAGE));
            Pop_Up.getInstance().display_popup(Pop_Up.PHOTO_CAPTION_USER_BOUTIQUE, _local2, this.post_boutique_photo);
        }
        function post_boutique_photo(_arg1:String):void{
            MainViewController.getInstance().show_snapshot_effect();
            var _local2:BitmapData = generate_bitmap_data((960 / 760), (960 / 760), 960, 612);
            FacebookConnector.post_boutique_photo(_local2, current_floor, _arg1, Album.TYPE_BOUTIQUES);
        }
        function add_models(){
            this.modelViewControllers.forEach(function (_arg1:UserBoutiqueModelViewController, _arg2:int, _arg3:Vector.<UserBoutiqueModelViewController>){
                modelContainer.addChildAt(_arg1, _arg1.data.z_pos);
            });
        }

    }
}//package com.viroxoty.fashionista.user_boutique

