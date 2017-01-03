// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.DecorBoutique

package com.viroxoty.fashionista.boutique{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Decor;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.data.Item;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class DecorBoutique extends AbstractBoutique {

        protected var decors:Vector.<Decor>;
        protected var boutique_model_mc:MovieClip;
        protected var boutique_model_controller:BoutiqueModel;
        protected var rows:int = 3;

        public function DecorBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
            Tracer.out(("new DecorBoutique: " + boutique_name));
            items_per_page = 18;
        }
        override public function get_catalog_data():void{
            DataManager.getInstance().get_boutique_decor(boutique.id, this.decor_loaded);
        }
        public function decor_loaded(data:Array):void{
            var process:Function;
            process = function (_arg1:Object, _arg2:int, _arg3:Array){
                decors.push(Decor.parseServerData(_arg1));
            };
            Tracer.out((("DecorBoutique > decor_loaded : loaded " + data.length) + " decors"));
            this.decors = new Vector.<Decor>();
            data.forEach(process);
            total_data = this.decors.length;
            if (total_data > 0)
            {
                this.check_show_shop_btn();
            };
        }
        override public function init():void{
            var _local1:BoutiqueModel;
            var _local3:int;
            super.init();
            catalog_mc = loc.item_ui;
            catalog_mc.emporio_menu.visible = false;
            catalog_mc.separates_menu.visible = false;
            catalog_mc.tops_menu.visible = false;
            catalog_mc.bottoms_menu.visible = false;
            catalog_mc.accessories_menu.visible = false;
            catalog_mc.jewelry_menu.visible = false;
            catalog_mc.resort_menu.visible = false;
            setup_catalog();
            loc.tip1_alt.x = boutique.avatar_position.x;
            loc.tip1_alt.y = boutique.avatar_position.y;
            loc.tip1_alt.name_txt.gotoAndStop(boutique.id);
            var _local2:int = boutique.models.length;
            Tracer.out((_local2 + " boutique models"));
            while (_local3 < _local2)
            {
                if (boutique.avatar_scale > 0)
                {
                    Tracer.out("creating boutique model");
                    _local1 = new BoutiqueModel();
                    _local1.init();
                    _local1.get_boutique_model_for(this, boutique.models[_local3]);
                };
                _local3++;
            };
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE)
            {
                catalog_mc.visible = false;
            };
        }
        public function set_boutique_model(_arg1:MovieClip, _arg2:BoutiqueModelDataObject, _arg3:BoutiqueModel):void{
            var _local4:Item;
            var _local5:String;
            var _local6:String;
            var _local9:int;
            this.boutique_model_mc = _arg1;
            this.boutique_model_mc.x = _arg2.position.x;
            this.boutique_model_mc.y = _arg2.position.y;
            this.boutique_model_mc.scaleX = _arg2.scale;
            this.boutique_model_mc.scaleY = _arg2.scale;
            this.boutique_model_mc.visible = false;
            this.boutique_model_mc.alpha = 0;
            loc.addChildAt(this.boutique_model_mc, 2);
            _arg3.set_styles(_arg2.style);
            var _local7:Vector.<Item> = _arg2.items;
            var _local8:int = _local7.length;
            while (_local9 < _local8)
            {
                _local4 = _local7[_local9];
                _local5 = _local4.category;
                _local6 = _local4.swf;
                _arg3.display_item(_local5, _local6, _local8);
                _local9++;
            };
            _arg3.addEventListener("model_ready", this.model_ready);
        }
        function model_ready(_arg1:Event):void{
            _arg1.target.removeEventListener("model_ready", this.model_ready);
            this.check_show_shop_btn();
        }
        function check_show_shop_btn(){
            var _local1:Boolean;
            Tracer.out(("check_show_shop_btn > total_data = " + total_data));
            if (((loc.tip1_alt.visible) || (catalog_mc.visible)))
            {
                return;
            };
            if (total_data > 0)
            {
                if (boutique.models.length == 0)
                {
                    _local1 = true;
                } else
                {
                    if (boutique.models[0].scale == 0)
                    {
                        if (this.boutique_model_mc)
                        {
                            this.boutique_model_mc.alpha = 1;
                        };
                        _local1 = true;
                    } else
                    {
                        if (this.boutique_model_mc != null)
                        {
                            _local1 = true;
                        };
                    };
                };
            };
            if (_local1)
            {
                show_shop_btn();
                if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
                {
                    loc.shop_arrow.visible = true;
                    if (boutique.level < 2)
                    {
                        loc.tip1_alt.visible = true;
                    };
                };
            };
        }
        override protected function display_catalog(e:MouseEvent):void{
            var show_items:Function;
            show_items = function (_arg1:Event):void{
                if (catalog_mc.alpha < 1)
                {
                    catalog_mc.alpha = (catalog_mc.alpha + 0.4);
                } else
                {
                    catalog_mc.removeEventListener(Event.ENTER_FRAME, show_items);
                    load_items();
                };
            };
            if (loc.tip1_alt.visible)
            {
                loc.tip1_alt.visible = false;
            };
            loc.shop_arrow.visible = false;
            Tracer.out("display_catalog");
            current_item = 0;
            next_mc.visible = false;
            prev_mc.visible = false;
            next_mc.gotoAndStop(2);
            prev_mc.gotoAndStop(2);
            if (total_data > (current_item + items_per_page))
            {
                next_mc.gotoAndStop(1);
                next_mc.visible = true;
                next_mc.buttonMode = true;
                next_mc.mouseEnabled = true;
                next_mc.mouseChildren = true;
                prev_mc.visible = true;
                prev_mc.buttonMode = false;
                prev_mc.mouseEnabled = false;
                prev_mc.mouseChildren = false;
            };
            catalog_items.x = 0;
            if (shop_btn.visible == true)
            {
                shop_btn.visible = false;
                catalog_mc.alpha = 0;
                catalog_mc.visible = true;
                catalog_mc.addEventListener(Event.ENTER_FRAME, show_items);
            } else
            {
                this.load_items();
            };
        }
        protected function load_items():void{
            var i:int;
            var swf:String;
            var url:String;
            var image_request:URLRequest;
            var image_loader:Loader;
            var image_sprite:Sprite;
            var c:Class;
            var outline_mc:MovieClip;
            var ow:Number;
            var oh:Number;
            var image_loaded:Function;
            var xpos:int = 30;
            var ypos:int = 20;
            var max:int = Math.min((current_item + items_per_page), total_data);
            i = current_item;
            while (i < max)
            {
                image_loaded = function (_arg1:Event){
                    var _local2:Loader = LoaderInfo(_arg1.currentTarget).loader;
                    var _local3:Rectangle = Util.getVisibleBoundingRectForAsset(_local2);
                    _local2.x = -(_local3.x);
                    _local2.y = -(_local3.y);
                    var _local4:Number = (ow / _local3.width);
                    var _local5:Number = (oh / _local3.height);
                    var _local6:Number = Math.min(_local4, _local5);
                    var _local7:Sprite = (_local2.parent as Sprite);
                    _local7.scaleX = _local6;
                    _local7.scaleY = _local6;
                    _local7.x = (5 + ((ow - (_local3.width * _local6)) / 2));
                    _local7.y = (5 + ((oh - (_local3.height * _local6)) / 2));
                };
                swf = boutique_data.ITEM[i].SWF;
                url = (Constants.SERVER_BOUTIQUE_ITEMS + swf);
                image_request = new URLRequest(url);
                image_loader = new Loader();
                image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
                image_loader.load(image_request);
                image_sprite = new Sprite();
                image_sprite.name = "mc";
                image_sprite.addChild(image_loader);
                c = BoutiqueManager.getInstance().class_by_name("item_outline");
                outline_mc = new (c)();
                outline_mc.x = xpos;
                outline_mc.y = ypos;
                ow = (outline_mc.width - 10);
                oh = (outline_mc.height - 10);
                outline_mc.name = swf;
                outline_mc.addChild(image_sprite);
                catalog_items.addChild(outline_mc);
                outline_mc.buttonMode = true;
                outline_mc.addEventListener(MouseEvent.CLICK, this.selected_item);
                outline_mc.addEventListener(MouseEvent.MOUSE_OVER, this.item_over);
                outline_mc.addEventListener(MouseEvent.MOUSE_OUT, this.item_out);
                ypos = (ypos + (outline_mc.height + 5));
                if (((i + 1) % this.rows) == 0)
                {
                    xpos = (xpos + (outline_mc.width + 15));
                    ypos = 20;
                };
                i = (i + 1);
            };
        }
        override protected function show_next(_arg1:MouseEvent):void{
            clear_catalog();
            current_item = (current_item + items_per_page);
            this.load_items();
            Util.enable_button(prev_mc);
            if ((current_item + items_per_page) >= total_data)
            {
                Util.disable_button(next_mc);
                next_mc.gotoAndStop(2);
            };
        }
        override protected function show_previous(_arg1:MouseEvent):void{
            clear_catalog();
            current_item = (current_item - items_per_page);
            this.load_items();
            Util.enable_button(next_mc);
            if (current_item == 0)
            {
                Util.disable_button(prev_mc);
                prev_mc.gotoAndStop(2);
            };
        }
        override protected function item_over(_arg1:MouseEvent):void{
            Tracer.out("item_over");
            var _local2:DisplayObject = MovieClip(_arg1.currentTarget).getChildByName("mc");
            _local2.filters = [glow_effect];
        }
        override protected function item_out(_arg1:MouseEvent):void{
            var _local2:DisplayObject = MovieClip(_arg1.currentTarget).getChildByName("mc");
            _local2.filters = [];
        }
        protected function selected_item(_arg1:MouseEvent):void{
            var _local2:XML;
            var _local3:Item;
            var _local4:int;
            while (_local4 < total_data)
            {
                _local2 = boutique_data.ITEM[_local4];
                if (_arg1.currentTarget.name == _local2.SWF)
                {
                    _local3 = new Item();
                    _local3.parseServerXML(_local2);
                    UserData.getInstance().buy_item(_local3);
                    return;
                };
                _local4++;
            };
        }

    }
}//package com.viroxoty.fashionista.boutique

