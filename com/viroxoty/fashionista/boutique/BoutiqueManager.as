// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.BoutiqueManager

package com.viroxoty.fashionista.boutique{
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class BoutiqueManager {

        public static const TYPE_ITEM:int = 1;
        public static const TYPE_LOOK:int = 2;
        public static const TYPE_DRESSING_ROOM:int = 3;
        public static const TYPE_GIFT_STORE:int = 4;
        public static const TYPE_DRESSES:int = 5;
        public static const TYPE_SEPARATES:int = 6;
        public static const TYPE_EMPORIO:int = 7;
        public static const TYPE_JEWELRY:int = 8;
        public static const TYPE_ACCESSORIES:int = 9;
        public static const TYPE_PETS:int = 10;
        public static const TYPE_RESORT:int = 11;

        private static var _instance:BoutiqueManager;

        public var boutiques:Array;
        public var boutique_controller:Object;
        private var boutiqueAppDomain:ApplicationDomain;
        private var mc:MovieClip;
        private var boutique_type:int;
        private var boutique:BoutiqueDataObject;

        public function BoutiqueManager(){
            Tracer.out("new BoutiqueManager");
            this.boutiques = CityManager.getInstance().boutiques;
        }
        public static function getInstance():BoutiqueManager{
            if (_instance == null)
            {
                _instance = new (BoutiqueManager)();
            };
            return (_instance);
        }

        public function class_by_name(_arg1:String):Class{
            if (this.boutiqueAppDomain)
            {
                return (Class(this.boutiqueAppDomain.getDefinition(_arg1)));
            };
            return (null);
        }
        public function setup_boutique_by_name(_arg1:String):void{
            var _local2:BoutiqueDataObject;
            var _local4:int;
            var _local3:int = this.boutiques.length;
            while (_local4 < _local3)
            {
                _local2 = (this.boutiques[_local4] as BoutiqueDataObject);
                if (_local2.short_name == _arg1)
                {
                    this.setup_boutique(_local2);
                };
                _local4++;
            };
        }
        function get_boutique_data(_arg1:BoutiqueDataObject):void{
            DataManager.getInstance().get_boutique_data(_arg1, this.loaded_boutique_data);
        }
        public function loaded_boutique_data(_arg1:BoutiqueDataObject, _arg2:String):void{
            var _local3:String;
            var _local4:Object = Json.decode(_arg2);
            for (_local3 in _local4)
            {
                Tracer.out(((("   " + _local3) + " = ") + _local4[_local3]));
            };
            Tracer.out(("bdo is " + _arg1));
            _arg1.type = _local4.Boutique_category_ID;
            if (_arg1.type == TYPE_ITEM)
            {
                _arg1.categories = ((_local4.closet_categories) ? _local4.closet_categories.split(",") : null);
                if (_arg1.categories.length == 1)
                {
                    Tracer.out(("boutique is a special category type " + _arg1.categories[0]));
                    switch (_arg1.categories[0])
                    {
                        case "5":
                            _arg1.type = TYPE_ACCESSORIES;
                            break;
                        case "11":
                            _arg1.type = TYPE_JEWELRY;
                            break;
                        case "13":
                            _arg1.type = TYPE_PETS;
                            break;
                        case "4":
                    };
                } else
                {
                    if (_arg1.categories.length == 2)
                    {
                        if (_local4.closet_categories == "2,3")
                        {
                            _arg1.type = TYPE_SEPARATES;
                        };
                    } else
                    {
                        if (_arg1.categories.length == 5)
                        {
                            if (_arg1.categories[0] == "2")
                            {
                                _arg1.type = TYPE_EMPORIO;
                            };
                            if (_arg1.categories[0] == "c")
                            {
                                _arg1.type = TYPE_RESORT;
                            };
                        };
                    };
                };
            };
            _arg1.dress_types = ((_local4.dress_type) ? _local4.dress_type.split(",") : null);
            if (_arg1.type == TYPE_LOOK)
            {
                if (_arg1.dress_types)
                {
                    _arg1.type = TYPE_DRESSES;
                };
            };
            _arg1.music = ((_local4.music) ? _local4.music : CityManager.getInstance().get_city_music(_arg1.city_id));
            _arg1.background_is_swf = int(_local4.background_swf);
            _arg1.set_models(_local4.models);
            this.setup_boutique(_arg1);
        }
        public function setup_boutique(_arg1:BoutiqueDataObject):void{
            var _local2:String;
            var _local3:URLRequest;
            var _local4:Loader;
            Tracer.out(("setup_boutique " + _arg1.name));
            if (UserData.getInstance().level < _arg1.level)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_TOO_LOW, "boutique", {
                    "name":_arg1.short_name,
                    "level":_arg1.level
                });
                return;
            };
            if (UserData.getInstance().mini_level < _arg1.mini_level)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_TOO_LOW, "boutique", {
                    "name":_arg1.short_name,
                    "mini_level":_arg1.mini_level
                });
                return;
            };
            MainViewController.getInstance().show_preloader();
            if (_arg1.background_url == null)
            {
                Tracer.out(("need to load boutique data for " + _arg1.short_name));
                this.get_boutique_data(_arg1);
                return;
            };
            this.boutique = _arg1;
            this.boutique_type = _arg1.type;
            Tracer.out(((("setup_boutique: " + _arg1.short_name) + ", ") + this.boutique_type));
            Main.getInstance().set_section("boutique");
            if (this.boutiqueAppDomain)
            {
                this.setup_asset();
            } else
            {
                _local2 = ((Constants.SERVER_SWF + Constants.BOUTIQUE_FILENAME) + ".swf");
                _local3 = new URLRequest(_local2);
                _local4 = new Loader();
                _local4.contentLoaderInfo.addEventListener(Event.COMPLETE, this.boutique_loaded);
                _local4.load(_local3);
            };
        }
        public function boutique_loaded(_arg1:Event):void{
            Tracer.out("BoutiqueManager > boutique_loaded");
            this.boutiqueAppDomain = (_arg1.target as LoaderInfo).applicationDomain;
            this.setup_asset();
        }
        function setup_asset():void{
            var _local1:Class = this.class_by_name("asset");
            this.mc = new (_local1)();
            this.mc.tip1.visible = false;
            this.mc.tip1_alt.visible = false;
            this.mc.tip2.visible = false;
            this.mc.tip3.visible = false;
            this.mc.tip4.visible = false;
            this.mc.nav_tip.visible = false;
            this.mc.gift_tip1.visible = false;
            this.mc.gift_tip2.visible = false;
            this.mc.gift_tip3.visible = false;
            this.mc.shop_btn.stop();
            this.mc.shop_btn.visible = false;
            this.mc.shop_arrow.visible = false;
            this.mc.look_ui.visible = false;
            this.mc.item_ui.visible = false;
            this.mc.gift_ui.visible = false;
            this.mc.pets_ui.visible = false;
            this.mc.catalog_tip.visible = false;
            this.mc.model_tip.visible = false;
            var _local2:String = this.boutique.background_url;
            var _local3:AssetDataObject = new AssetDataObject();
            _local3.parseURL(_local2);
            AssetManager.getInstance().getAssetFor(_local3, {"assetLoaded":this.bg_loaded});
        }
        public function bg_loaded(_arg1:DisplayObject, _arg2:String):void{
            Tracer.out(("BoutiqueManager > bg_loaded: " + _arg2));
            MainViewController.getInstance().hide_preloader();
            this.mc.addChildAt(_arg1, 0);
            MainViewController.getInstance().add_swf(this.mc);
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE)
            {
                return;
            };
            if (UserData.getInstance().shopping_welcome)
            {
                PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
            };
        }
        public function enable_boutique():Object{
            switch (this.boutique_type)
            {
                case TYPE_ITEM:
                    this.boutique_controller = new ItemBoutique(this.boutique);
                    break;
                case TYPE_LOOK:
                    this.boutique_controller = new LookBoutique(this.boutique);
                    break;
                case TYPE_DRESSES:
                    this.boutique_controller = new DressBoutique(this.boutique);
                    break;
                case TYPE_SEPARATES:
                    this.boutique_controller = new SeparatesBoutique(this.boutique);
                    break;
                case TYPE_EMPORIO:
                    this.boutique_controller = new EmporioBoutique(this.boutique);
                    break;
                case TYPE_JEWELRY:
                    this.boutique_controller = new JewelryBoutique(this.boutique);
                    break;
                case TYPE_ACCESSORIES:
                    this.boutique_controller = new AccessoriesBoutique(this.boutique);
                    break;
                case TYPE_GIFT_STORE:
                    this.boutique_controller = new GiftBoutique(this.boutique);
                    break;
                case TYPE_PETS:
                    this.boutique_controller = new PetBoutique(this.boutique);
                    break;
                case TYPE_RESORT:
                    this.boutique_controller = new ResortBoutique(this.boutique);
                    break;
            };
            this.boutique_controller.init();
            this.boutique_controller.get_catalog_data();
            return (this.boutique_controller);
        }
        public function is_themed():Boolean{
            if ((((this.boutique_type == TYPE_LOOK)) || ((this.boutique_type == TYPE_DRESSES))))
            {
                return (true);
            };
            return (false);
        }

    }
}//package com.viroxoty.fashionista.boutique

