// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.DressingRoom

package com.viroxoty.fashionista{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Styles;
    import com.viroxoty.fashionista.data.UserBoutique;
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import com.viroxoty.fashionista.ui.ScrollingDirectoryController;
    import com.viroxoty.fashionista.user_boutique.UserBoutiqueModelViewController;
    import com.viroxoty.fashionista.user_boutique.ModelUIController;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import com.viroxoty.fashionista.data.Decor;
    import com.viroxoty.fashionista.user_boutique.DecorViewController;
    import flash.display.DisplayObjectContainer;
    import com.viroxoty.fashionista.events.GameEvent;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class DressingRoom extends EventDispatcher {

        private static var _instance:DressingRoom;
        public static var user_default_clothing:Vector.<Item> = new Vector.<Item>();
        public static var user_default_styles:Styles = new Styles();
        public static var user_default_pet_model:Item;
        public static var user_default_pet_accessories:Vector.<Item> = new Vector.<Item>();
        public static var category_id_dict:Object = {
            "pants":1,
            "skirts":2,
            "purses":3,
            "hats":4,
            "blouses":5,
            "dress_long":6,
            "dress_short":7,
            "coats":22,
            "shoes":8,
            "jackets":9,
            "tights":10,
            "scarves":11,
            "belts":12,
            "dresses":13,
            "gloves":14,
            "bracelets":16,
            "rings":17,
            "necklaces":18,
            "earrings":19,
            "glasses":20,
            "masks":21,
            "tiaras":15,
            "shorts":25,
            "bathing_suits":26,
            "dogs":32,
            "wing_coats":27,
            "wigs":28,
            "leashes":33,
            "cats":35,
            "exotics":36
        };
        public static var category_data_dict:Object = {};
        private static var total_items:int;

        public var boutique:UserBoutique;
        var current_floor:int;
        var floor:UserDecor;
        var wall:UserDecor;
        var model:UserBoutiqueModel;
        var directory_controller:ScrollingDirectoryController;
        var model_vc:UserBoutiqueModelViewController;
        public var model_ui_controller:ModelUIController;
        var avatar_controller:AvatarController;
        public var view:MovieClip;
        var wallContainer:MovieClip;
        var mirrorContainer:MovieClip;
        var floorContainer:MovieClip;
        var rugContainer:MovieClip;
        var decorContainer:MovieClip;
        var lightsContainer:MovieClip;
        var modelContainer:Sprite;
        var dressupContainer:Sprite;
        var total_assets:int;
        var loaded_assets:int;

        public function DressingRoom(){
            Tracer.out("new DressingRoom");
        }
        public static function getNewInstance():DressingRoom{
            _instance = new (DressingRoom)();
            return (_instance);
        }
        public static function getCurrentInstance():DressingRoom{
            return (_instance);
        }
        public static function get_default_clothing():Vector.<Item>{
            var _local1:Item;
            var _local2:Vector.<Item> = new Vector.<Item>();
            _local1 = new Item();
            _local1.id = 0;
            _local1.category = "dress_short";
            _local1.swf = (Constants.SERVER_BOUTIQUE_ITEMS + "/dressing_room_default/dressingroom_dress.swf");
            _local2.push(_local1);
            _local1 = new Item();
            _local1.id = 411;
            _local1.category = "shoes";
            _local1.swf = (Constants.SERVER_BOUTIQUE_ITEMS + "Sh31.swf");
            _local2.push(_local1);
            return (_local2);
        }
        public static function set_user_defaults(_arg1:Vector.<Item>, _arg2:Styles, _arg3:Item, _arg4:Vector.<Item>):void{
            user_default_clothing = _arg1;
            user_default_styles = _arg2;
            user_default_pet_model = _arg3;
            user_default_pet_accessories = _arg4;
        }
        public static function update_user_default_clothing(_arg1:Item):void{
            var _local2:Boolean;
            var _local4:int;
            var _local3:int = user_default_clothing.length;
            while (_local4 < _local3)
            {
                if (user_default_clothing[_local4].category == _arg1.category)
                {
                    user_default_clothing[_local4] = _arg1;
                    _local2 = true;
                    break;
                };
                _local4++;
            };
            if (_local2 == false)
            {
                user_default_clothing.push(_arg1);
            };
        }
        public static function save_user_defaults():void{
            var _local1:String;
            Tracer.out("DressingRoom > save_user_defaults");
            if (user_default_clothing.length == 0)
            {
                Tracer.out("DressingRoom > save_user_defaults: bailing because user_default_clothing.length == 0");
                return;
            };
            if (user_default_clothing[0].id == 0)
            {
                Tracer.out("DressingRoom > save_user_defaults: bailing because user_default_clothing[0].id == 0");
                return;
            };
            if (user_default_pet_model)
            {
                _local1 = String(user_default_pet_model.id);
                DataManager.getInstance().save_user_default_avatar(_instance.model.item_ids, _instance.model.styles, _local1);
            } else
            {
                DataManager.getInstance().save_user_default_avatar(_instance.model.item_ids, _instance.model.styles);
            };
        }
        public static function remove_user_item(_arg1:int){
            var _local2:Item;
            var _local4:int;
            var _local3:int = user_default_clothing.length;
            while (_local4 < _local3)
            {
                _local2 = user_default_clothing[_local4];
                if (_arg1 == _local2.id)
                {
                    Tracer.out((("remove_user_item: removing id " + _local2.id) + " from user_default_clothing"));
                    user_default_clothing.splice(_local4, 1);
                    return;
                };
                _local4++;
            };
        }
        public static function remove_user_pet_model():void{
            user_default_pet_model = null;
        }
        public static function sort_closet(_arg1:Array):void{
            var _local2:int;
            var _local3:Item;
            Tracer.out("DressingRoom > sort_closet");
            var _local4:int = _arg1.length;
            while (_local2 < _local4)
            {
                _local3 = _arg1[_local2];
                sort_item(_local3);
                _local2++;
            };
            total_items = _local4;
            Tracer.out((("DressingRoom > sort_closet complete: " + total_items) + " total_items"));
        }
        public static function sort_item(_arg1:Item):void{
            var _local2:String = _arg1.category;
            if (_local2 == "hat")
            {
                _local2 = "hats";
            } else
            {
                if (_local2 == "jacket")
                {
                    _local2 = "jackets";
                } else
                {
                    if (_local2 == "purse")
                    {
                        _local2 = "purses";
                    } else
                    {
                        if (_local2 == "scarf")
                        {
                            _local2 = "scarves";
                        } else
                        {
                            if (_local2 == "bracelet")
                            {
                                _local2 = "bracelets";
                            } else
                            {
                                if (_local2 == "ring")
                                {
                                    _local2 = "rings";
                                } else
                                {
                                    if (_local2 == "mask")
                                    {
                                        _local2 = "masks";
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (category_data_dict[_local2] == null)
            {
                Tracer.out(("   creating new category array for " + _local2));
                category_data_dict[_local2] = new Vector.<Item>();
            };
            var _local3:Vector.<Item> = category_data_dict[_local2];
            _local3.push(_arg1);
            total_items++;
            if (ModelUIController.current_instance())
            {
                ModelUIController.current_instance().check_reload_category(_local2);
            };
        }
        public static function get_category_data(_arg1:String):Vector.<Item>{
            if (category_data_dict[_arg1] == null)
            {
                Tracer.out(("   creating new category array for " + _arg1));
                category_data_dict[_arg1] = new Vector.<Item>();
            };
            return (category_data_dict[_arg1]);
        }
        public static function item_is_style(_arg1:Item):Boolean{
            var _local2:String = _arg1.category;
            return ((((((((((_local2 == "hair_styles")) || ((_local2 == "colors")))) || ((_local2 == "eyebrows")))) || ((_local2 == "lips")))) || ((_local2 == "eyes"))));
        }

        public function destroy():void{
            Tracer.out("DressingRoom > destroy");
            dispatchEvent(new GameEvent(Events.DRESSING_ROOM_DESTROY));
            if ((((user_default_clothing.length == 0)) && ((user_default_pet_model == null))))
            {
                user_default_clothing = get_default_clothing();
            };
            this.boutique = null;
            if (this.directory_controller)
            {
                this.directory_controller.destroy();
            };
            this.model_ui_controller.destroy();
            this.model_ui_controller.removeEventListener(Events.GAME_EVENT, this.model_ui_controller_handler);
            this.view = null;
            this.wallContainer = null;
            this.mirrorContainer = null;
            this.floorContainer = null;
            this.rugContainer = null;
            this.decorContainer = null;
            this.lightsContainer = null;
            this.modelContainer = null;
        }
        public function load(){
            Tracer.out("loading dressing room swf");
            Main.getInstance().set_section(Constants.SECTION_DRESSING_ROOM);
            MainViewController.getInstance().load_asset(Constants.DRESSING_ROOM_FILENAME, this.loaded_dressing_room);
        }
        public function loaded_dressing_room(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("DressingRoom > loaded_dressing_room");
            this.view = _arg1;
            MainViewController.getInstance().swap_swf(this.view);
        }
        public function init():void{
            Tracer.out("DressingRoom > init");
            this.view.visits_ui.visible = false;
            this.view.a_list_btn.visible = false;
            this.view.floor_ui.visible = false;
            this.view.star_btn.visible = false;
            this.view.heart_btn.visible = false;
            this.view.decorate_btn.visible = false;
            this.view.befriend_btn.visible = false;
            Util.hideTips(this.view);
            this.model_ui_controller = new ModelUIController(this.view.model_ui, ModelUIController.SECTION_DRESSING_ROOM);
            this.model_ui_controller.load_item_data();
            this.model_ui_controller.addEventListener(Events.GAME_EVENT, this.model_ui_controller_handler);
            this.wallContainer = this.view.wallContainer;
            this.mirrorContainer = this.view.mirrorContainer;
            this.floorContainer = this.view.floorContainer;
            this.rugContainer = this.view.rugContainer;
            this.decorContainer = this.view.decorContainer;
            this.lightsContainer = this.view.lightsContainer;
            this.dressupContainer = new Sprite();
            this.dressupContainer.graphics.beginFill(0, 0.3);
            this.dressupContainer.graphics.drawRect(0, 0, Constants.SCREEN_WIDTH, Constants.GAME_SCREEN_HEIGHT);
            this.dressupContainer.graphics.endFill();
            this.view.addChild(this.dressupContainer);
            this.modelContainer = new Sprite();
            this.view.addChild(this.modelContainer);
            this.view.addChild(this.view.model_ui);
            this.view.directory.visible = false;
            if (UserData.getInstance().first_time_visit())
            {
                this.setup_user_boutique(UserBoutique.get_starting_boutique());
            } else
            {
                this.setup_user_boutique(UserData.getInstance().boutique);
            };
        }
        public function reset_model(_arg1=null){
            Tracer.out("DressingRoom > reset_model");
            this.model_vc.zoom_out();
            this.model_vc.avatar_controller.remove_all();
            this.set_default_clothing();
            user_default_pet_model = null;
            user_default_styles = new Styles();
            this.model_ui_controller.show_dressing_room_default();
        }
        public function check_show_enter_look():void{
        }
        public function photo_ui_enter_look(_arg1:Event):void{
        }
        public function hide_agent_btn():void{
        }
        public function show_enter_look(){
            this.view.model_ui.enter_look_btn.visible = true;
        }
        public function hide_enter_look(){
            this.view.model_ui.enter_look_btn.visible = false;
        }
        function setup_user_boutique(_arg1:UserBoutique){
            Tracer.out("DressingRoom > setup_user_boutique", false);
            this.boutique = _arg1;
            this.current_floor = MyBoutique.last_visited_floor;
            this.show_current_floor();
            if (this.directory_controller)
            {
                this.directory_controller.set_current_user_boutique(this.boutique);
                this.directory_controller.init_with_view(this.view.directory);
                this.directory_controller.hide_directory();
            };
            this.view.model_ui.visible = true;
            Tracer.out("DressingRoom > setup_user_boutique: calling display closet", false);
            this.model_ui_controller.display_closet();
            Util.fadeOut(this.view.preloader);
        }
        function get_boutique_fail(){
            Tracer.out("get_boutique_fail");
        }
        function load_boutique_floor(_arg1:int){
            DataManager.getInstance().load_user_boutique_floor(DataManager.user_id, _arg1, this.boutique, this.loaded_boutique_floor, this.load_boutique_floor_fail);
        }
        function loaded_boutique_floor(){
            this.show_current_floor();
        }
        function load_boutique_floor_fail(){
            Tracer.out("load_boutique_floor_fail");
        }
        function show_current_floor(){
            var setup_avatar:Function;
            var userDecor:UserDecor;
            var decor:Decor;
            var dvc:DecorViewController;
            var i:int;
            setup_avatar = function (_arg1:Event){
                show_user_default();
                model_vc.to_dressup_position();
            };
            Tracer.out("DressingRoom > show_current_floor", false);
            if (this.boutique.floor_loaded(this.current_floor) == false)
            {
                Tracer.out("DressingRoom > show_current_floor: floor data not loaded yet", false);
                this.load_boutique_floor(this.current_floor);
                return;
            };
            this.clear_floor();
            var decor_data:Array = this.boutique.get_decor_for_floor(this.current_floor);
            this.total_assets = decor_data.length;
            Tracer.out((((("BoutiqueVisit > show_current_floor : floor " + this.current_floor) + " has ") + this.total_assets) + " decors"));
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
            if (this.current_floor == 1)
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
            Tracer.out("DressingRoom > show_current_floor: setting up model", false);
            this.model = new UserBoutiqueModel();
            this.model.items = user_default_clothing;
            this.model.style_obj = user_default_styles;
            this.model_vc = new UserBoutiqueModelViewController(this.model);
            this.avatar_controller = this.model_vc.avatar_controller;
            this.modelContainer.addChild(this.model_vc);
            this.model_ui_controller.set_model(this.model_vc);
            this.model_vc.addEventListener(UserBoutiqueModelViewController.AVATAR_READY, setup_avatar, false, 0, true);
            this.model_vc.init_avatar(AvatarController.MODE_DRESSING_ROOM);
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
                    return;
                case "walls":
                    this.wallContainer.addChild(_arg1);
                    return;
                case "mirrors":
                    _local2 = Math.min(_arg1.data.z_pos, this.mirrorContainer.numChildren);
                    this.mirrorContainer.addChildAt(_arg1, _local2);
                    return;
                case "rugs":
                    _local2 = Math.min(_arg1.data.z_pos, this.rugContainer.numChildren);
                    this.rugContainer.addChildAt(_arg1, _local2);
                    return;
                case "lights":
                    _local2 = Math.min(_arg1.data.z_pos, this.lightsContainer.numChildren);
                    this.lightsContainer.addChildAt(_arg1, _local2);
                    return;
                default:
                    _local2 = Math.min(_arg1.data.z_pos, this.decorContainer.numChildren);
                    this.decorContainer.addChildAt(_arg1, _local2);
            };
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
        public function show_user_default():void{
            Tracer.out(("DressingRoom > show_user_default: clothing is " + user_default_clothing));
            this.avatar_controller.reset_item_counter();
            if ((((user_default_clothing.length == 0)) || ((user_default_clothing[0].id == 0))))
            {
                Tracer.out("   no user-chosen default clothing");
                this.set_default_clothing();
                this.hide_enter_look();
            } else
            {
                this.model.items = user_default_clothing;
                this.avatar_controller.dress_with_items(user_default_clothing);
            };
            if (user_default_pet_model)
            {
                this.avatar_controller.add_pet_model(user_default_pet_model.category, user_default_pet_model.swf, user_default_pet_model.id);
            };
            this.avatar_controller.set_styles(user_default_styles);
            this.model_ui_controller.update_highlights();
        }
        function set_default_clothing():void{
            user_default_clothing = get_default_clothing();
            this.avatar_controller.dressup_default();
        }
        function model_ui_controller_handler(_arg1:GameEvent){
            dispatchEvent(_arg1);
        }

    }
}//package com.viroxoty.fashionista

