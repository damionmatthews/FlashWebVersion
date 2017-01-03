// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.DecorManager

package com.viroxoty.fashionista.user_boutique{
    import com.viroxoty.fashionista.data.UserBoutique;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import com.viroxoty.fashionista.data.Decor;
    import flash.events.Event;
    import com.viroxoty.fashionista.DataManager;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorManager {

        static const WALL_X:Number = 380;
        static const WALL_Y:Number = 180;
        static const WALL_HEIGHT:Number = 360;
        static const FLOOR_X:Number = 380;
        static const FLOOR_Y:Number = 422.5;
        static const FLOOR_HEIGHT:Number = 125;
        static const ONSCREEN_PIXELS_MIN:int = 5;
        static const DECOR_OFFSCREEN_TOLERANCE:Number = 1;
        static const MODEL_OFFSCREEN_TOLERANCE:Number = 0.8;
        public static const EVENT_DECOR_LOADED:String = "EVENT_DECOR_LOADED";
        public static const EVENT_REMOVE_DECOR:String = "EVENT_REMOVE_DECOR";
        public static const EVENT_REMOVE_MODEL:String = "EVENT_REMOVE_MODEL";
        public static const EVENT_RESET_MODEL:String = "EVENT_RESET_MODEL";

        private static var _instance:DecorManager;

        var boutique:UserBoutique;
        var decors:Vector.<DecorViewController>;
        var floor:UserDecor;
        var wall:UserDecor;
        var currentFloor:int;
        var total_assets:int;
        var loaded_assets:int;
        var models:Vector.<UserBoutiqueModel>;
        var view:MovieClip;
        var wallContainer:MovieClip;
        var wallBackground:Sprite;
        var mirrorContainer:MovieClip;
        var floorContainer:MovieClip;
        var floorBackground:Sprite;
        var rugContainer:MovieClip;
        var decorContainer:MovieClip;
        var lightsContainer:MovieClip;
        var modelContainer:Sprite;
        var dressupBlocker:Sprite;
        var dressupContainer:Sprite;
        var dragLayer:Sprite;
        var transformLayer:Sprite;
        var transforming_obj:UserBoutiqueObjectViewController;
        var pending_decor_purchase:Decor;
        var pending_decor_x:Number;
        var pending_decor_y:Number;
        var modelViewControllers:Vector.<UserBoutiqueModelViewController>;
        var model_ui_controller:ModelUIController;

        public static function getInstance():DecorManager{
            if (_instance == null)
            {
                _instance = new (DecorManager)();
            };
            return (_instance);
        }
        public static function not_wall_floor(_arg1:DecorViewController):Boolean{
            return (((!((_arg1.data.decor.category == DecorCategories.WALLS))) && (!((_arg1.data.decor.category == DecorCategories.FLOORS)))));
        }

        public function reset(){
            this.boutique = null;
            this.view = null;
            this.decors = new Vector.<DecorViewController>();
            this.floor = null;
            this.wall = null;
            this.currentFloor = 0;
            this.total_assets = 0;
            this.loaded_assets = 0;
            this.transforming_obj = null;
            this.pending_decor_purchase = null;
            this.modelViewControllers = null;
            this.model_ui_controller.destroy();
            this.model_ui_controller = null;
            this.decorContainer = null;
            this.floorContainer = null;
            this.rugContainer = null;
            this.wallContainer = null;
            this.mirrorContainer = null;
            this.lightsContainer = null;
            this.transformLayer = null;
            this.wallBackground = null;
            this.floorBackground = null;
        }
        public function init(_arg1:MovieClip){
            this.view = _arg1;
            this.model_ui_controller = new ModelUIController(this.view.model_ui);
            this.model_ui_controller.addEventListener(ModelUIController.MODEL_UI_CLOSED, this.model_ui_closed, false, 0, true);
            this.model_ui_controller.addEventListener(ModelUIController.MODEL_UI_OPENED, this.model_ui_opened, false, 0, true);
            this.wallContainer = this.view.wallContainer;
            this.mirrorContainer = this.view.mirrorContainer;
            this.floorContainer = this.view.floorContainer;
            this.rugContainer = this.view.rugContainer;
            this.decorContainer = this.view.decorContainer;
            this.lightsContainer = this.view.lightsContainer;
            this.wallBackground = new Sprite();
            this.wallBackground.graphics.beginFill(0, 0);
            this.wallBackground.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, WALL_HEIGHT);
            this.view.addChildAt(this.wallBackground, (this.view.getChildIndex(this.wallContainer) + 1));
            this.wallBackground.addEventListener(MouseEvent.MOUSE_DOWN, this.click_background, false, 0, true);
            this.floorBackground = new Sprite();
            this.floorBackground.graphics.beginFill(0, 0);
            this.floorBackground.graphics.drawRect(0, WALL_HEIGHT, Constants.SCREEN_WIDTH, FLOOR_HEIGHT);
            this.view.addChildAt(this.floorBackground, (this.view.getChildIndex(this.floorContainer) + 1));
            this.floorBackground.addEventListener(MouseEvent.MOUSE_DOWN, this.click_background, false, 0, true);
            this.modelContainer = new Sprite();
            this.view.addChildAt(this.modelContainer, (this.view.getChildIndex(this.lightsContainer) + 1));
            this.dragLayer = new Sprite();
            this.view.addChildAt(this.dragLayer, (this.view.getChildIndex(this.modelContainer) + 1));
            this.transformLayer = new Sprite();
            this.view.addChildAt(this.transformLayer, (this.view.getChildIndex(this.dragLayer) + 1));
            this.dressupBlocker = new Sprite();
            this.dressupBlocker.graphics.beginFill(0, 0.3);
            this.dressupBlocker.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.GAME_SCREEN_HEIGHT);
            this.dressupBlocker.graphics.endFill();
            this.view.addChild(this.dressupBlocker);
            this.dressupBlocker.visible = false;
            this.dressupContainer = new Sprite();
            this.view.addChild(this.dressupContainer);
            this.dressupContainer.visible = false;
            this.view.addChild(this.view.model_ui);
            this.view.model_ui.visible = false;
        }
        public function set_boutique(_arg1:UserBoutique){
            Tracer.out(("DecorManager > set_boutique for user " + _arg1.user_id));
            this.boutique = _arg1;
        }
        public function show_boutique_floor(f:int){
            var init_controller:Function;
            var userDecor:UserDecor;
            var decor:Decor;
            var i:int;
            init_controller = function (_arg1:UserBoutiqueModel, _arg2:int, _arg3:Vector.<UserBoutiqueModel>){
                if (_arg1.placed == false)
                {
                    return;
                };
                add_model_view_controller(_arg1);
            };
            this.clear_floor();
            this.currentFloor = f;
            var decor_data:Array = this.boutique.get_decor_for_floor(f);
            this.total_assets = decor_data.length;
            Tracer.out((((("DecorManager > show_boutique_floor : floor " + f) + " has ") + this.total_assets) + " decors"));
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
            Tracer.out(((("DecorManager > show_boutique_floor: wall = " + this.wall) + ", floor = ") + this.floor));
            if (this.wall == null)
            {
                decor = Decor.getDefaultWall();
                userDecor = decor.newInstance();
                this.add_wall(userDecor);
            };
            if (this.floor == null)
            {
                decor = Decor.getDefaultFloor();
                userDecor = decor.newInstance();
                this.add_floor(userDecor);
            };
            this.models = this.boutique.get_models_for_floor(f);
            Tracer.out(("DecorManager > show_boutique_floor: number of models is " + this.models.length));
            this.modelViewControllers = new Vector.<UserBoutiqueModelViewController>();
            this.models.forEach(init_controller);
            this.add_models();
        }
        function add_model_view_controller(_arg1:UserBoutiqueModel):UserBoutiqueModelViewController{
            var _local2:UserBoutiqueModelViewController = new UserBoutiqueModelViewController(_arg1);
            _local2.addEventListener(UserBoutiqueModelViewController.AVATAR_READY, this.setup_avatar);
            _local2.init_avatar(AvatarController.MODE_MY_BOUTIQUE, true);
            _local2.addEventListener(MouseEvent.MOUSE_DOWN, this.click_model, false, 0, true);
            _local2.doubleClickEnabled = true;
            _local2.mouseChildren = false;
            _local2.addEventListener(MouseEvent.DOUBLE_CLICK, this.double_click_model, false, 0, true);
            this.modelViewControllers.push(_local2);
            return (_local2);
        }
        function setup_avatar(_arg1:Event){
            var _local2:UserBoutiqueModelViewController = (_arg1.currentTarget as UserBoutiqueModelViewController);
            this.model_ui_controller.set_model(_local2);
            if ((((UserData.getInstance().visits == 1)) && (Tracker.first_time_my_boutique_model_init)))
            {
                Tracker.first_time_my_boutique_model_init = false;
                this.model_ui_controller.show_dressing_room_default();
                return;
            };
            Tracer.out(("setup_avatar: items count is " + _local2.data.items.length));
            _local2.avatar_controller.dress_with_items(_local2.data.items);
            this.model_ui_controller.update_model_items(false);
        }
        public function decor_purchased(_arg1:UserDecor){
            if (this.pending_decor_purchase != _arg1.decor)
            {
                Tracer.out("decor_purchased > no pending_decor_purchase!");
                return;
            };
            this.pending_decor_purchase = null;
            if (_arg1.decor.category == DecorCategories.WALLS)
            {
                this.place_wall(_arg1);
                return;
            };
            if (_arg1.decor.category == DecorCategories.FLOORS)
            {
                this.place_floor(_arg1);
                return;
            };
            _arg1.x_pos = this.pending_decor_x;
            _arg1.y_pos = this.pending_decor_y;
            this.pending_decor_x = 0;
            this.pending_decor_y = 0;
            this.set_z_pos(_arg1);
            var _local2:DecorViewController = this.load_user_decor(_arg1);
            this.transform_object(_local2);
            this.update_decor_data(_arg1);
            this.check_place_decor();
        }
        public function add_decor(_arg1:DecorViewController){
            var _local2:UserDecor = _arg1.data;
            if (_local2.id == 0)
            {
                UserData.getInstance().buy_decor(_local2.decor);
                this.pending_decor_purchase = _local2.decor;
                this.pending_decor_x = _arg1.x;
                this.pending_decor_y = _arg1.y;
                return;
            };
            _local2.x_pos = _arg1.x;
            _local2.y_pos = _arg1.y;
            this.set_z_pos(_local2);
            this.decors.push(_arg1);
            this.add_decor_to_container(_arg1);
            this.transform_object(_arg1);
            this.update_decor_data(_local2);
            this.check_place_decor(false);
        }
        public function place_wall(_arg1:UserDecor){
            Tracer.out(("place_wall: userDecor.decor.id = " + _arg1.decor.id));
            if (((this.wall) && ((this.wall.id > 0))))
            {
                DataManager.getInstance().remove_decor(this.wall);
            };
            this.add_wall(_arg1);
            this.update_decor_data(_arg1);
        }
        public function place_floor(_arg1:UserDecor){
            if (((this.floor) && ((this.floor.id > 0))))
            {
                DataManager.getInstance().remove_decor(this.floor);
            };
            this.add_floor(_arg1);
            this.update_decor_data(_arg1);
        }
        function update_decor_data(_arg1:UserDecor){
            _arg1.floor = this.currentFloor;
            this.boutique.add_decor_to_floor(_arg1);
            DataManager.getInstance().position_decor(_arg1);
        }
        function check_place_decor(_arg1:Boolean=true){
            if (Tracker.first_time_my_boutique_place_decor)
            {
                Tracer.out("check_place_decor > first decor placed, will show Resize notification after popups closed");
                Tracker.first_time_my_boutique_place_decor = false;
                Tracker.track(Tracker.PLACE_DECOR, Tracker.FIRST_TIME_MY_BOUTIQUE);
                if (_arg1)
                {
                    MainViewController.getInstance().addEventListener(MainViewController.CLOSED_POPUP, this.show_resize, false, 0, true);
                } else
                {
                    this.show_resize();
                };
            };
        }
        function show_resize(_arg1=null){
            Tracer.out("show_resize");
            MainViewController.getInstance().removeEventListener(MainViewController.CLOSED_POPUP, this.show_resize);
            Notification.getInstance().add_notification(Notification.MY_BOUTIQUE_RESIZE);
        }
        public function preview_floor(_arg1:Decor){
            Tracer.out("preview_floor");
            var _local2:DecorViewController = new DecorViewController(_arg1.newInstance());
            _local2.loadAsset();
            this.remove_floor_preview();
            this.floorContainer.addChild(_local2);
            Tracer.out(("floorContainer.numChildren = " + this.floorContainer.numChildren));
        }
        public function preview_wall(_arg1:Decor){
            var _local2:DecorViewController = new DecorViewController(_arg1.newInstance());
            _local2.loadAsset();
            this.remove_wall_preview();
            this.wallContainer.addChild(_local2);
        }
        public function remove_floor_preview(){
            var _local1:int = (((this.floor)==null) ? 0 : 1);
            while (this.floorContainer.numChildren > _local1)
            {
                this.floorContainer.removeChildAt(_local1);
            };
        }
        public function remove_wall_preview(){
            var _local1:int = (((this.wall)==null) ? 0 : 1);
            while (this.wallContainer.numChildren > _local1)
            {
                this.wallContainer.removeChildAt(_local1);
            };
        }
        public function reset_boutique_level(){
            var i:int;
            var pending_changes:* = 0;
            if (((this.wall) && ((this.wall.id > 0))))
            {
                pending_changes++;
            };
            if (((this.floor) && ((this.floor.id > 0))))
            {
                pending_changes++;
            };
            pending_changes = (pending_changes + this.decors.length);
            pending_changes++;
            MyBoutique.getInstance().delay_launch_exclamation(pending_changes);
            var dm:DataManager = DataManager.getInstance();
            if (((this.wall) && ((this.wall.id > 0))))
            {
                dm.remove_decor(this.wall);
            };
            if (((this.floor) && ((this.floor.id > 0))))
            {
                dm.remove_decor(this.floor);
            };
            var l:int = this.decors.length;
            while (i < l)
            {
                dm.remove_decor(this.decors[i].data);
                i = (i + 1);
            };
            this.modelViewControllers.forEach(function (_arg1:UserBoutiqueModelViewController, _arg2:int, _arg3:Vector.<UserBoutiqueModelViewController>){
                _arg1.reset();
            });
            this.model_ui_controller.ui.enter_look_btn.visible = false;
            this.clear_floor();
            this.add_models();
            var decor:Decor = Decor.getDefaultWall();
            var userDecor:UserDecor = decor.newInstance();
            this.add_wall(userDecor);
            decor = Decor.getDefaultFloor();
            userDecor = decor.newInstance();
            this.add_floor(userDecor);
        }
        public function hide_transform_box():UserBoutiqueObjectViewController{
            var _local1:UserBoutiqueObjectViewController;
            if (this.transforming_obj)
            {
                _local1 = this.transforming_obj;
                this.deselect();
                return (_local1);
            };
            return (null);
        }
        public function reshow_transform_box(_arg1:UserBoutiqueObjectViewController){
            this.transform_object(_arg1);
        }
        public function place_first_model(){
            this.place_model(this.models[0]);
        }
        public function place_second_model(){
            this.place_model(this.models[1]);
        }
        function place_model(_arg1:UserBoutiqueModel){
            _arg1.placed = true;
            var _local2:UserBoutiqueModelViewController = this.add_model_view_controller(_arg1);
            this.modelContainer.addChild(_local2);
            _local2.model.z_pos = this.modelContainer.getChildIndex(_local2);
            DataManager.getInstance().update_my_boutique_model(_arg1);
        }
        public function model_at_index(_arg1:int):UserBoutiqueModel{
            return (this.modelViewControllers[_arg1].model);
        }
        public function dress_first_model(){
            this.dress_model_at_index(0);
        }
        public function dress_second_model(){
            this.dress_model_at_index(1);
        }
        function double_click_model(_arg1:Event):void{
            Tracer.out("double_click_model");
            var _local2:UserBoutiqueModelViewController = (_arg1.currentTarget as UserBoutiqueModelViewController);
            this.model_ui_controller.set_model(_local2);
            this.toggle_model_ui();
        }
        function dress_model_at_index(_arg1:int){
            var _local2:UserBoutiqueModel = (((_arg1)==0) ? MyBoutique.getInstance().first_model : MyBoutique.getInstance().second_model);
            var _local3:UserBoutiqueModelViewController = (((this.modelViewControllers[0].model)==_local2) ? this.modelViewControllers[0] : this.modelViewControllers[1]);
            this.model_ui_controller.set_model(_local3);
            this.toggle_model_ui();
        }
        function toggle_model_ui(){
            if (this.model_ui_controller.ui.visible)
            {
                this.model_ui_controller.ui.visible = false;
                this.model_ui_closed();
            } else
            {
                this.model_ui_opened();
                if (this.model_ui_controller.visible == false)
                {
                    this.model_ui_controller.display_closet();
                };
                this.model_ui_controller.ui.visible = true;
                if (this.model_ui_controller.first_time_open)
                {
                    this.model_ui_controller.first_time_open = false;
                    this.model_ui_controller.load_item_data();
                };
            };
        }
        public function check_close_model_ui(){
            if (this.model_ui_controller.ui.visible)
            {
                this.model_ui_controller.hide_catalog();
                this.model_ui_closed();
            };
        }
        public function model_ui_is_open():Boolean{
            return (this.model_ui_controller.ui.visible);
        }
        function model_ui_opened(e=null){
            var checkHide:Function;
            checkHide = function (_arg1:UserBoutiqueModelViewController, _arg2:int, _arg3:Vector.<UserBoutiqueModelViewController>){
                if (model_ui_controller.model_vc != _arg1)
                {
                    _arg1.visible = false;
                };
            };
            this.deselect();
            this.model_ui_controller.model_vc.to_dressup_position();
            this.dressupContainer.addChild(this.model_ui_controller.model_vc);
            this.dressupContainer.visible = true;
            this.dressupBlocker.visible = true;
            this.model_ui_controller.model_vc.removeEventListener(MouseEvent.MOUSE_DOWN, this.click_model);
            this.model_ui_controller.model_vc.mouseChildren = true;
            this.model_ui_controller.model_vc.removeEventListener(MouseEvent.DOUBLE_CLICK, this.double_click_model);
            this.model_ui_controller.model_vc.avatar_controller.restore_model_interactivity();
            MyBoutique.getInstance().hide_like_btn();
            MyBoutique.getInstance().hide_directory_tab();
            this.modelViewControllers.forEach(checkHide);
        }
        function model_ui_closed(e=null){
            var showModel:Function;
            showModel = function (_arg1:UserBoutiqueModelViewController, _arg2:int, _arg3:Vector.<UserBoutiqueModelViewController>){
                _arg1.visible = true;
            };
            this.model_ui_controller.model_vc.revert_position();
            this.modelContainer.addChild(this.model_ui_controller.model_vc);
            this.dressupBlocker.visible = false;
            this.dressupContainer.visible = false;
            this.model_ui_controller.model_vc.addEventListener(MouseEvent.MOUSE_DOWN, this.click_model, false, 0, true);
            this.model_ui_controller.model_vc.mouseChildren = false;
            this.model_ui_controller.model_vc.addEventListener(MouseEvent.DOUBLE_CLICK, this.double_click_model, false, 0, true);
            this.model_ui_controller.model_vc.avatar_controller.remove_model_interactivity();
            MyBoutique.getInstance().show_like_btn();
            MyBoutique.getInstance().show_directory_tab();
            DecorBrowserController.getInstance().check_show_browser_tip();
            this.modelViewControllers.forEach(showModel);
        }
        public function hide_model_ui():Boolean{
            if (this.model_ui_controller.visible)
            {
                this.model_ui_controller.model_vc.revert_position();
                this.view.model_ui.visible = false;
                this.dressupBlocker.visible = false;
                return (true);
            };
            return (false);
        }
        public function reshow_model_ui(){
            this.model_ui_controller.model_vc.to_dressup_position();
            this.view.model_ui.visible = true;
            this.dressupBlocker.visible = true;
        }
        public function show_enter_look(){
            this.view.model_ui.enter_look_btn.visible = true;
        }
        public function hide_enter_look(){
            this.view.model_ui.enter_look_btn.visible = false;
        }
        function add_floor(_arg1:UserDecor){
            this.floor = _arg1;
            while (this.floorContainer.numChildren > 0)
            {
                this.floorContainer.removeChildAt(0);
            };
            var _local2:DecorViewController = new DecorViewController(_arg1);
            _local2.loadAsset();
            this.floorContainer.addChild(_local2);
        }
        function add_wall(_arg1:UserDecor){
            Tracer.out("add_wall");
            this.wall = _arg1;
            while (this.wallContainer.numChildren > 0)
            {
                this.wallContainer.removeChildAt(0);
            };
            var _local2:DecorViewController = new DecorViewController(_arg1);
            _local2.loadAsset();
            this.wallContainer.addChild(_local2);
        }
        function load_user_decor(_arg1:UserDecor):DecorViewController{
            var _local2:DecorViewController = new DecorViewController(_arg1);
            this.add_decor_to_container(_local2);
            _local2.addEventListener(EVENT_DECOR_LOADED, this.decor_asset_loaded, false, 0, true);
            _local2.loadAsset();
            if (_arg1.decor.category == "walls")
            {
                this.wall = _arg1;
            } else
            {
                if (_arg1.decor.category == "floors")
                {
                    this.floor = _arg1;
                } else
                {
                    this.decors.push(_local2);
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
            if (not_wall_floor(_arg1))
            {
                _arg1.addEventListener(MouseEvent.MOUSE_DOWN, this.click_decor, false, 0, true);
            };
        }
        function set_z_pos(_arg1:UserDecor){
            var _local2:MovieClip;
            if (_arg1.decor.category == "rugs")
            {
                _local2 = this.rugContainer;
            } else
            {
                if (_arg1.decor.category == "mirrors")
                {
                    _local2 = this.mirrorContainer;
                } else
                {
                    if (_arg1.decor.category == "lights")
                    {
                        _local2 = this.lightsContainer;
                    } else
                    {
                        _local2 = this.decorContainer;
                    };
                };
            };
            _arg1.z_pos = _local2.numChildren;
        }
        function clear_floor(){
            this.decors = new Vector.<DecorViewController>();
            this.floor = null;
            this.wall = null;
            this.total_assets = 0;
            this.clear_container(this.decorContainer);
            this.clear_container(this.rugContainer);
            this.clear_container(this.mirrorContainer);
            this.clear_container(this.lightsContainer);
            this.clear_container(this.floorContainer);
            this.clear_container(this.wallContainer);
            this.clear_container(this.modelContainer);
            this.removeTransformBox();
            this.transforming_obj = null;
        }
        function clear_container(_arg1:DisplayObjectContainer){
            while (_arg1.numChildren > 0)
            {
                _arg1.removeChildAt(0);
            };
        }
        function click_decor(_arg1:MouseEvent):void{
            var _local2:DecorViewController = (_arg1.currentTarget as DecorViewController);
            Tracer.out(("DecorManager > click_decor: " + _local2.data.id));
            this.transform_object(_local2);
            this.start_drag();
            this.update_decor_depths();
        }
        function click_model(_arg1:MouseEvent):void{
            var _local2:UserBoutiqueModelViewController = (_arg1.currentTarget as UserBoutiqueModelViewController);
            this.transform_object(_local2);
            this.start_drag();
            this.update_model_depths();
        }
        public function start_drag(){
            this.transforming_obj.x_offset = this.transforming_obj.mouseX;
            this.transforming_obj.y_offset = this.transforming_obj.mouseY;
            this.dragLayer.addChild(this.transforming_obj);
            this.transforming_obj.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.update_position, false, 0, true);
            this.transforming_obj.stage.addEventListener(MouseEvent.MOUSE_UP, this.drop, false, 0, true);
            Tracer.out(((("start_drag : new start position is " + this.transforming_obj.x) + ", ") + this.transforming_obj.y));
        }
        public function drop(_arg1=null):void{
            this.transforming_obj.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.update_position);
            this.transforming_obj.stage.removeEventListener(MouseEvent.MOUSE_UP, this.drop);
            Tracer.out(((("drop : end position is " + this.transforming_obj.x) + ", ") + this.transforming_obj.y));
            if ((this.transforming_obj is DecorViewController))
            {
                this.drop_decor((this.transforming_obj as DecorViewController));
            } else
            {
                if ((this.transforming_obj is UserBoutiqueModelViewController))
                {
                    this.drop_model((this.transforming_obj as UserBoutiqueModelViewController));
                };
            };
        }
        function drop_decor(_arg1:DecorViewController){
            var _local2:UserDecor;
            var _local3:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
            if ((((((((((_arg1.x + _local3.x) + (_local3.width * DECOR_OFFSCREEN_TOLERANCE)) < ONSCREEN_PIXELS_MIN)) || ((((_arg1.x + _local3.x) + (_local3.width * (1 - DECOR_OFFSCREEN_TOLERANCE))) > (Constants.SCREEN_WIDTH - ONSCREEN_PIXELS_MIN))))) || ((((_arg1.y + _local3.y) + (_local3.height * DECOR_OFFSCREEN_TOLERANCE)) < ONSCREEN_PIXELS_MIN)))) || ((((_arg1.y + _local3.y) + (_local3.height * (1 - DECOR_OFFSCREEN_TOLERANCE))) > (Constants.GAME_SCREEN_HEIGHT - ONSCREEN_PIXELS_MIN)))))
            {
                this.remove_decor();
            } else
            {
                _local2 = _arg1.data;
                _local2.x_pos = _arg1.x;
                _local2.y_pos = _arg1.y;
                this.set_z_pos(_local2);
                Tracer.out(("drop: new z_pos is " + _local2.z_pos));
                this.add_decor_to_container(_arg1);
                DataManager.getInstance().position_decor(_local2);
            };
        }
        function drop_model(_arg1:UserBoutiqueModelViewController){
            this.modelContainer.addChild(_arg1);
            var _local2:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
            _arg1.x = Math.max(_arg1.x, (ONSCREEN_PIXELS_MIN - (_local2.x + (_local2.width * MODEL_OFFSCREEN_TOLERANCE))));
            _arg1.x = Math.min(_arg1.x, ((Constants.SCREEN_WIDTH - ONSCREEN_PIXELS_MIN) - (_local2.x + (_local2.width * (1 - MODEL_OFFSCREEN_TOLERANCE)))));
            _arg1.y = Math.max(_arg1.y, (ONSCREEN_PIXELS_MIN - (_local2.y + (_local2.height * MODEL_OFFSCREEN_TOLERANCE))));
            _arg1.y = Math.min(_arg1.y, ((Constants.GAME_SCREEN_HEIGHT - ONSCREEN_PIXELS_MIN) - (_local2.y + (_local2.height * (1 - MODEL_OFFSCREEN_TOLERANCE)))));
            this.updateTransformBox();
            var _local3:UserBoutiqueModel = _arg1.data;
            _local3.x_pos = _arg1.x;
            _local3.y_pos = _arg1.y;
            _local3.z_pos = this.modelContainer.getChildIndex(_arg1);
            DataManager.getInstance().update_my_boutique_model(_local3);
        }
        function update_position(_arg1:MouseEvent):void{
            this.transforming_obj.x = (this.dragLayer.mouseX - this.transforming_obj.x_offset);
            this.transforming_obj.y = (this.dragLayer.mouseY - this.transforming_obj.y_offset);
            this.transforming_obj.dispatchEvent(new Event(UserBoutiqueObjectViewController.CHANGED_POSITION));
        }
        function update_decor_depths(){
            this.update_decors_for_container(this.decorContainer);
            this.update_decors_for_container(this.rugContainer);
            this.update_decors_for_container(this.mirrorContainer);
            this.update_decors_for_container(this.lightsContainer);
        }
        function update_decors_for_container(_arg1:MovieClip){
            var _local2:DecorViewController;
            var _local3:int;
            var _local5:int;
            var _local4:int = _arg1.numChildren;
            while (_local5 < _local4)
            {
                _local2 = DecorViewController(_arg1.getChildAt(_local5));
                _local3 = _local2.data.z_pos;
                _local2.data.z_pos = _local5;
                if (_local3 != _local5)
                {
                    DataManager.getInstance().position_decor(_local2.data);
                };
                _local5++;
            };
        }
        function update_model_depths(){
            var _local1:UserBoutiqueModelViewController;
            var _local2:int;
            var _local4:int;
            var _local3:int = this.modelContainer.numChildren;
            while (_local4 < _local3)
            {
                _local1 = UserBoutiqueModelViewController(this.modelContainer.getChildAt(_local4));
                _local2 = _local1.data.z_pos;
                _local1.data.z_pos = _local4;
                if (_local2 != _local4)
                {
                    DataManager.getInstance().update_my_boutique_model(_local1.data);
                };
                _local4++;
            };
        }
        function transform_object(_arg1:UserBoutiqueObjectViewController):void{
            this.removeTransformBox();
            this.showTransformBox(_arg1);
            this.transforming_obj = _arg1;
        }
        function showTransformBox(_arg1:UserBoutiqueObjectViewController):void{
            var _local2:TransformBox = new TransformBox(_arg1, this.decorContainer);
            this.transformLayer.addChild(_local2);
            _local2.init();
            if ((_arg1 is DecorViewController))
            {
                _local2.addEventListener(EVENT_REMOVE_DECOR, this.remove_decor, false, 0, true);
            } else
            {
                if ((_arg1 is UserBoutiqueModelViewController))
                {
                    _local2.addEventListener(EVENT_RESET_MODEL, this.reset_model, false, 0, true);
                    _local2.addEventListener(EVENT_REMOVE_MODEL, this.remove_model, false, 0, true);
                };
            };
        }
        function click_background(_arg1:MouseEvent){
            this.deselect();
        }
        function deselect(_arg1=null):void{
            this.removeTransformBox();
        }
        function updateTransformBox():void{
            TransformBox(this.transformLayer.getChildAt(0)).update();
        }
        function removeTransformBox():void{
            var _local1:DisplayObject;
            while (this.transformLayer.numChildren > 0)
            {
                _local1 = this.transformLayer.getChildAt(0);
                if ((_local1 is TransformBox))
                {
                    TransformBox(_local1).destroy();
                };
                _local1.removeEventListener(EVENT_REMOVE_DECOR, this.remove_decor);
                _local1.removeEventListener(EVENT_RESET_MODEL, this.reset_model);
                _local1.removeEventListener(EVENT_REMOVE_MODEL, this.remove_model);
                this.transformLayer.removeChildAt(0);
            };
            this.transforming_obj = null;
        }
        function remove_decor(_arg1=null){
            this.transforming_obj.parent.removeChild(this.transforming_obj);
            this.transforming_obj.reset_data();
            DataManager.getInstance().remove_decor((this.transforming_obj as DecorViewController).data);
            this.removeTransformBox();
        }
        function reset_model(_arg1:Event){
            var _local2:TransformBox = (_arg1.currentTarget as TransformBox);
            var _local3:UserBoutiqueModelViewController = (_local2.viewController as UserBoutiqueModelViewController);
            this.transforming_obj.parent.removeChild(this.transforming_obj);
            this.removeTransformBox();
            _local3.reset();
            this.modelContainer.addChild(_local3);
            this.update_model_depths();
        }
        function remove_model(_arg1:Event){
            var _local2:TransformBox = (_arg1.currentTarget as TransformBox);
            var _local3:UserBoutiqueModelViewController = (_local2.viewController as UserBoutiqueModelViewController);
            this.transforming_obj.parent.removeChild(this.transforming_obj);
            Util.remove(this.modelViewControllers, _local3);
            this.removeTransformBox();
            _local3.data.placed = false;
            DataManager.getInstance().update_my_boutique_model(_local3.data);
            this.update_model_depths();
        }
        function add_models(){
            this.modelViewControllers.forEach(function (_arg1:UserBoutiqueModelViewController, _arg2:int, _arg3:Vector.<UserBoutiqueModelViewController>){
                modelContainer.addChildAt(_arg1, _arg1.data.z_pos);
            });
        }

    }
}//package com.viroxoty.fashionista.user_boutique

