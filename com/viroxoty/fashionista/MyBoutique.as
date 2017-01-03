// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.MyBoutique

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.user_boutique.UserBoutiqueController;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.user_boutique.DecorBrowserController;
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import com.viroxoty.fashionista.data.UserBoutique;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import com.viroxoty.fashionista.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class MyBoutique extends UserBoutiqueController {

        private static var _instance:MyBoutique;
        static var last_visited_floor:int = 1;
        static var visits:int = 0;

        var decor_browser:MovieClip;
        var decor_browser_controller:DecorBrowserController;
        var launch_exclamation_delay:int = 0;

        public function MyBoutique(){
            decor_manager = DecorManager.getInstance();
        }
        public static function getInstance():MyBoutique{
            if (_instance == null)
            {
                _instance = new (MyBoutique)();
            };
            return (_instance);
        }

        public function destroy():void{
            Tracer.out("MyBoutique > destroy");
            this.decor_browser = null;
            boutique = null;
            MainViewController.getInstance().hide_decor_browser();
            decor_manager.reset();
            directory_controller.destroy();
            this.hide_like_btn();
            Pop_Up.getInstance().removeEventListener(Pop_Up.POPUP_OPENED, this.hide_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.init_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.OPENED_MESSAGE_CENTER, this.hide_like_btn);
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.init_like_btn);
        }
        public function load(){
            Tracer.out("loading user_boutique swf");
            Main.getInstance().set_section(Constants.SECTION_MY_BOUTIQUE);
            MainViewController.getInstance().load_asset(Constants.USER_BOUTIQUE_FILENAME, this.loaded_boutique);
            Tracer.out(("return_startup_visit is " + this.return_startup_visit()));
            if (this.return_startup_visit() == false)
            {
                this.load_decor_browser();
            };
        }
        public function loaded_boutique(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("MyBoutique > loaded_boutique");
            view = _arg1;
            MainViewController.getInstance().swap_swf(view);
        }
        public function loaded_decor_browser(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("MyBoutique > loaded_decor_browser");
            this.decor_browser = _arg1;
            this.decor_browser_controller = DecorBrowserController.getInstance();
            this.decor_browser_controller.init(this.decor_browser);
            if (!this.return_startup_visit())
            {
                this.check_ready();
            } else
            {
                this.setup_decor_browser();
                TopMenu.getInstance().set_active();
            };
            MainViewController.getInstance().show_decor_browser(this.decor_browser, this.return_startup_visit());
            Tracer.out("MyBoutique > loaded_decor_browser: added to footer_container");
        }
        override public function init():void{
            var _local1:Boolean;
            Tracer.out("MyBoutique > init");
            visits++;
            if (UserData.getInstance().shopping_welcome)
            {
                _local1 = true;
                PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
            };
            if (((Tracker.first_time_my_boutique_welcome) && (!((MainViewController.getInstance().first_section == Constants.SECTION_MY_BOUTIQUE)))))
            {
                Tracker.first_time_my_boutique_welcome = false;
                if (Tracker.first_time_my_boutique_start)
                {
                    if (_local1)
                    {
                        EventHandler.getInstance().queue_my_boutique_start_after_shopping();
                    } else
                    {
                        Tracker.first_time_my_boutique_start = false;
                        PopupIntro.getInstance().display_popup(PopupIntro.MY_BOUTIQUE_START);
                    };
                } else
                {
                    PopupIntro.getInstance().display_popup(PopupIntro.MY_BOUTIQUE_TIP);
                };
                Tracker.track(Tracker.CREATE, Tracker.FIRST_TIME_MY_BOUTIQUE);
            } else
            {
                if (((((UserData.getInstance().has_boutique) && ((UserData.getInstance().boutique_earnings > 0)))) && ((Tracker.shown_my_boutique_welcome_back == false))))
                {
                    if (MainViewController.getInstance().first_section != Constants.SECTION_MY_BOUTIQUE)
                    {
                        Tracker.shown_my_boutique_welcome_back = true;
                        this.hide_like_btn();
                        Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_WELCOME_BACK, UserData.getInstance().boutique_earnings);
                    };
                };
            };
            decor_manager.init(view);
            DataManager.getInstance().get_user_boutique(true, this.got_user_boutique, this.get_boutique_fail);
            Tracer.out("MyBoutique > init:  initializing UI");
            super.init();
            view.photo_btn.visible = false;
            view.befriend_btn.visible = false;
            view.a_list_btn.stop();
            view.a_list_btn.visible = false;
            Util.simpleButton(view.star_btn, this.make_star);
            Tracer.out("MyBoutique > init:  initializing floor UI");
            var _local2:MovieClip = view.floor_ui;
            _local2.up_btn.stop();
            _local2.up_btn.buttonMode = true;
            _local2.up_btn.addEventListener(MouseEvent.CLICK, this.next_floor, false, 0, true);
            _local2.up_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_floor_tip, false, 0, true);
            _local2.up_btn.addEventListener(MouseEvent.ROLL_OUT, hide_floor_tip, false, 0, true);
            _local2.down_btn.stop();
            _local2.down_btn.buttonMode = true;
            _local2.down_btn.addEventListener(MouseEvent.CLICK, this.prev_floor, false, 0, true);
            _local2.down_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_floor_tip, false, 0, true);
            _local2.down_btn.addEventListener(MouseEvent.ROLL_OUT, hide_floor_tip, false, 0, true);
            _local2.down_btn.visible = (current_floor > 1);
            Tracer.out("MyBoutique > init:  initializing like button UI");
            view.heart_btn.visible = false;
            view.tip_heart.visible = false;
            view.heart_btn.glow.visible = false;
            if (this.return_startup_visit())
            {
                Util.simpleButton(view.decorate_btn, this.click_decorate_btn);
                Util.simpleRolloverTip(view.decorate_btn, view.decorate_btn_tip);
            } else
            {
                view.decorate_btn.visible = false;
            };
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.init_like_btn, false, 0, true);
            Pop_Up.getInstance().addEventListener(Pop_Up.POPUP_OPENED, this.hide_like_btn, false, 0, true);
            MainViewController.getInstance().addEventListener(MainViewController.CLOSED_MESSAGE_CENTER, this.init_like_btn, false, 0, true);
            MainViewController.getInstance().addEventListener(MainViewController.OPENED_MESSAGE_CENTER, this.hide_like_btn, false, 0, true);
            BackGroundMusic.getInstance().set_music(Constants.CITY_MUSIC);
        }
        public function check_show_welcome_back():Boolean{
            Tracer.out("MyBoutique > check_show_welcome_back");
            if (((((UserData.getInstance().has_boutique) && ((UserData.getInstance().boutique_earnings > 0)))) && ((Tracker.shown_my_boutique_welcome_back == false))))
            {
                Tracker.shown_my_boutique_welcome_back = true;
                this.hide_like_btn();
                Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_WELCOME_BACK, UserData.getInstance().boutique_earnings);
                return (true);
            };
            return (false);
        }
        public function hide_like_btn(_arg1=null){
            External.hideLikeButton();
        }
        public function init_like_btn(_arg1=null){
            if (((MainViewController.getInstance().inMessageCenter()) || (MainViewController.getInstance().inGiftCenter())))
            {
                return;
            };
            if (MainViewController.getInstance().in_popup())
            {
                return;
            };
            var _local2:String = ((((Constants.FACEBOOK_APP_PAGE + "/index.php?boutique_owner=") + DataManager.user_id) + "&level=") + current_floor);
            External.initLikeButton("boutiqueLevel", _local2);
            this.show_like_btn();
        }
        public function show_like_btn(){
            if (decor_manager.model_ui_is_open())
            {
                return;
            };
            External.showLikeButton();
        }
        public function hide_directory(){
            directory_controller.hide_directory();
        }
        public function hide_directory_tab(){
            view.directory.visible = false;
        }
        public function show_directory_tab(){
            view.directory.visible = true;
        }
        public function hide_heart_btn(){
        }
        public function add_floor():void{
            boutique.add_floor();
            this.next_floor();
        }
        public function handle_decor_purchase(_arg1:UserDecor){
            Tracer.out("MyBoutique > handle_decor_purchase");
            this.decor_browser_controller.update_decor_counts(_arg1.decor);
            decor_manager.decor_purchased(_arg1);
            if (((((!((_arg1.decor.category == DecorCategories.WALLS))) && (!((_arg1.decor.category == DecorCategories.FLOORS))))) && (Tracker.first_time_my_boutique_buy_decor)))
            {
                Tracker.first_time_my_boutique_buy_decor = false;
                Tracker.track(Tracker.PURCHASE_DECOR, Tracker.FIRST_TIME_MY_BOUTIQUE);
                if (Tracker.first_time_my_boutique_place_decor)
                {
                    this.decor_browser_controller.check_decor_place_tip();
                };
                Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_DECORATE, this.click_decorate);
            } else
            {
                if (Tracker.first_time_my_boutique_buy_wall_floor)
                {
                    Tracker.first_time_my_boutique_buy_wall_floor = false;
                    Tracker.track(Tracker.PURCHASE_WALL_FLOOR, Tracker.FIRST_TIME_MY_BOUTIQUE);
                    Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_DECORATE, this.click_decorate);
                };
            };
            this.decor_browser_controller.hide_browser_tip();
        }
        public function click_decorate(){
            Tracker.track(Tracker.CLICK_DECORATE, Tracker.FIRST_TIME_MY_BOUTIQUE);
            this.decor_browser_controller.show_launch_exclamation();
        }
        public function delay_launch_exclamation(_arg1:int):void{
            this.launch_exclamation_delay = _arg1;
        }
        public function handle_decor_gift(_arg1:UserDecor){
            if (this.decor_browser_controller)
            {
                this.decor_browser_controller.decor_returned(_arg1);
                this.decor_browser_controller.update_decor_counts(_arg1.decor);
            };
        }
        public function decor_positioned(_arg1:UserDecor){
            if (this.decor_browser_controller)
            {
                this.decor_browser_controller.update_decor_counts(_arg1.decor);
            };
            this.check_show_launch_exclamation();
        }
        public function decor_removed(_arg1:UserDecor){
            boutique.remove_decor_from_floor(_arg1);
            if (this.decor_browser_controller)
            {
                this.decor_browser_controller.decor_returned(_arg1);
                this.decor_browser_controller.update_decor_counts(_arg1.decor);
                this.check_show_launch_exclamation();
            };
        }
        public function select_model():void{
            var _local1:DressingRoom = DressingRoom.getNewInstance();
            if (this.current_floor_model_count == 1)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.SELECT_MODEL, this.first_model, this.second_model, _local1.load, decor_manager.dress_first_model, this.buy_model);
            } else
            {
                if (this.first_model.placed == false)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.SELECT_MODEL, this.first_model, this.second_model, _local1.load, decor_manager.dress_second_model, decor_manager.place_first_model);
                } else
                {
                    if (this.second_model.placed == false)
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.SELECT_MODEL, this.first_model, this.second_model, _local1.load, decor_manager.dress_first_model, decor_manager.place_second_model);
                    } else
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.SELECT_MODEL, this.first_model, this.second_model, _local1.load, decor_manager.dress_first_model, decor_manager.dress_second_model);
                    };
                };
            };
        }
        public function get current_floor_model_count():int{
            return (boutique.get_models_for_floor(current_floor).length);
        }
        public function get first_model():UserBoutiqueModel{
            Tracer.out(("get_first_model: id is " + boutique.floors[current_floor].model.id));
            return (boutique.floors[current_floor].model);
        }
        public function get second_model():UserBoutiqueModel{
            if (this.current_floor_model_count > 1)
            {
                Tracer.out(("get_second_model: id is " + boutique.floors[current_floor].second_model.id));
                return (boutique.floors[current_floor].second_model);
            };
            Tracer.out("no second model");
            return (null);
        }
        public function model_updated():void{
            this.check_show_launch_exclamation();
        }
        public function buy_model():void{
            FacebookConnector.buy_second_model(current_floor);
        }
        public function add_second_model():void{
            boutique.add_model(current_floor);
            boutique.floors[current_floor].second_model.initAsSecondModel();
            decor_manager.place_second_model();
            decor_manager.dress_second_model();
        }
        public function check_show_enter_look():void{
            if (ModelUIController.current_instance().model_vc.data.items.length == 0)
            {
                decor_manager.hide_enter_look();
            } else
            {
                decor_manager.show_enter_look();
            };
        }
        public function show_caption_popup():void{
            var _local1:String = ("Come to the Opening of MyBoutique in Fashionista FaceOff!  " + Util.url_with_http(Constants.FACEBOOK_APP_PAGE));
            Pop_Up.getInstance().display_popup(Pop_Up.MY_BOUTIQUE_PHOTO_CAPTION, _local1, this.post_boutique_photo);
        }
        public function post_boutique_photo(_arg1:String):void{
            //MainViewController.getInstance().show_snapshot_effect();
            var _local2:BitmapData = generate_bitmap_data((960 / 760), (960 / 760), 960, 612);
			//var _local2:BitmapData = new BitmapData();
            FacebookConnector.post_boutique_photo(_local2, current_floor, _arg1, Album.TYPE_MY_BOUTIQUE);
        }
        public function launch_boutique():void{
            var launch_success:Function;
            launch_success = function (){
                boutique.active = true;
                UserData.getInstance().has_active_boutique = true;
                directory_controller.update_a_list();
                decor_browser_controller.update_launch_btn_after_launch();
            };
            if (boutique.active == false)
            {
                Tracker.track(Tracker.LAUNCH, Tracker.FIRST_TIME_MY_BOUTIQUE);
            };
            var png:ByteArray = this.upload_boutique_thumb();
            DataManager.getInstance().launch_boutique(png, current_floor, launch_success);
        }
        public function visit_level_return(_arg1:int):void{
            view.visits_ui.all_visits_txt.text = String(_arg1);
        }
        function got_user_boutique(_arg1:UserBoutique){
            boutique = _arg1;
            directory_controller.set_current_user_boutique(boutique);
            directory_controller.init_with_view(view.directory);
            if (UserData.getInstance().has_boutique == false)
            {
                directory_controller.hide_directory();
            };
            view.directory.visible = true;
            decor_manager.set_boutique(boutique);
            if (this.return_startup_visit())
            {
                this.setup_boutique();
            } else
            {
                this.check_ready();
            };
            UserData.getInstance().has_boutique = true;
            if (visits == 1)
            {
                this.hide_like_btn();
            };
            Util.fadeOut(view.preloader);
        }
        function get_boutique_fail(){
            Tracer.out("get_boutique_fail");
        }
        function load_boutique_floor(_arg1:int){
            DataManager.getInstance().load_user_boutique_floor(DataManager.user_id, _arg1, boutique, this.loaded_boutique_floor, this.load_boutique_floor_fail);
        }
        function loaded_boutique_floor(){
            this.show_current_floor();
        }
        function load_boutique_floor_fail(){
            Tracer.out("load_boutique_floor_fail");
        }
        function check_ready(){
            if (((boutique) && (this.decor_browser)))
            {
                this.setup_boutique();
                this.setup_decor_browser();
            };
        }
        function setup_boutique(){
            current_floor = boutique.entry_floor;
            this.show_current_floor();
            view.floor_ui.down_btn.visible = (current_floor > 1);
        }
        function setup_decor_browser(){
            this.decor_browser_controller.load_data();
            if ((((boutique.active == false)) && ((Tracker.first_time_my_boutique_session == false))))
            {
                this.decor_browser_controller.show_launch_exclamation();
            };
        }
        function show_current_floor(){
            last_visited_floor = current_floor;
            if (boutique.floor_loaded(current_floor) == false)
            {
                this.load_boutique_floor(current_floor);
                return;
            };
            view.floor_ui.floor_txt.text = String(current_floor);
            decor_manager.show_boutique_floor(current_floor);
            this.init_like_btn();
            DataManager.getInstance().visit_my_boutique_level(boutique.user_id, current_floor, this.visit_level_return);
        }
        function next_floor(_arg1:MouseEvent=null){
            if (current_floor == boutique.floorCount)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.ADD_FLOOR, (current_floor + 1));
                hide_floor_tip();
                return;
            };
            current_floor++;
            view.floor_ui.down_btn.visible = true;
            if (view.floor_tip.visible)
            {
                this.show_floor_tip();
            };
            this.show_current_floor();
        }
        function prev_floor(_arg1:MouseEvent=null){
            current_floor--;
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
                _local2 = (((current_floor)==boutique.floorCount) ? "Buy a New Level!" : "Go Up a Level");
            };
            if (((_arg1) && (_arg1.currentTarget)))
            {
                _arg1.currentTarget.gotoAndStop("on");
            };
            view.floor_tip.tip_txt.text = _local2;
            view.floor_tip.visible = true;
        }
        function upload_boutique_thumb():ByteArray{
            var _local1:BitmapData = generate_bitmap_data((120 / 760), (77 / 485), 120, 77);
            var _local2:ByteArray = PNGEncoder.encode(_local1);
            Tracer.out("MyBoutique > generated boutique thumb bitmapdata and png");
            return (_local2);
        }
        function check_show_launch_exclamation(){
            if (this.decor_browser_controller)
            {
                if ((((Tracker.first_time_my_boutique_launch == false)) && ((this.launch_exclamation_delay == 0))))
                {
                    this.decor_browser_controller.show_launch_exclamation();
                };
                if (this.launch_exclamation_delay > 0)
                {
                    Tracer.out(("check_show_launch_exclamation > launch_exclamation_delay = " + this.launch_exclamation_delay));
                    this.launch_exclamation_delay--;
                };
            };
        }
        function show_heart_glow(_arg1=null){
        }
        function hide_heart_glow(_arg1=null){
        }
        function show_like_popup(_arg1=null){
            Pop_Up.getInstance().display_popup(Pop_Up.LIKE_FASHIONISTA);
        }
        function make_star(_arg1=null):void{
            Pop_Up.getInstance().display_popup(Pop_Up.MAKE_ME_A_STAR);
        }
        function click_decorate_btn(_arg1=null):void{
            if (_arg1.currentTarget.clicked)
            {
                return;
            };
            _arg1.currentTarget.clicked = true;
            this.load_decor_browser();
        }
        function return_startup_visit():Boolean{
            return ((((MainViewController.getInstance().first_section == Constants.SECTION_MY_BOUTIQUE)) && ((visits < 2))));
        }
        function load_decor_browser(){
            MainViewController.getInstance().load_asset(Constants.DECOR_BROWSER_FILENAME, this.loaded_decor_browser);
        }

    }
}//package com.viroxoty.fashionista

