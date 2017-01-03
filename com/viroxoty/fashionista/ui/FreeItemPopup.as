// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.FreeItemPopup

package com.viroxoty.fashionista.ui{
    import com.viroxoty.fashionista.data.Item;
    import flash.display.MovieClip;
    import flash.text.TextFormat;
    import flash.text.Font;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.text.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class FreeItemPopup {

        private static var _instance:FreeItemPopup;

        var free_item:Item;
        var pending_open:Boolean;
        private var popup:MovieClip;

        public function FreeItemPopup(){
            Tracer.out("new FreeItemPopup");
        }
        public static function getInstance():FreeItemPopup{
            if (_instance == null)
            {
                _instance = new (FreeItemPopup)();
            };
            return (_instance);
        }

        public function open_popup():void{
            var _local1:TextFormat;
            var _local2:Font;
            var _local3:AssetDataObject;
            Tracer.out("FreeItemPopup > open popup");
            this.free_item = DataManager.getInstance().free_item;
            if (this.free_item == null)
            {
                return;
            };
            if (this.popup == null)
            {
                this.popup = (MainViewController.getInstance().get_game_asset(Pop_Up.FREE_ITEM_POPUP) as MovieClip);
                _local1 = new TextFormat();
                _local1.bold = true;
                _local2 = (MainViewController.getInstance().get_game_asset("gill_sans_bold") as Font);
                _local1.font = _local2.fontName;
                this.popup.item_txt.embedFonts = true;
                this.popup.item_txt.defaultTextFormat = _local1;
                this.popup.item_txt.text = (("FREE! " + this.free_item.name) + ".");
                _local3 = new AssetDataObject();
                _local3.parseURL(Util.url_with_http(this.free_item.model_png_url));
                AssetManager.getInstance().getAssetFor(_local3, {
                    "assetLoaded":this.item_image_loaded,
                    "loadFailed":this.item_image_load_failed
                });
                this.popup.accept_btn.buttonMode = true;
                this.popup.accept_btn.addEventListener(MouseEvent.CLICK, this.show_offer, false, 0, true);
            };
            this.show_popup();
        }
        public function item_image_loaded(_arg1:Bitmap, _arg2:String):void{
            this.popup.item_image.addChild(_arg1);
        }
        public function item_image_load_failed(_arg1:String):void{
            Tracer.out(("item_image_load_failed " + _arg1));
        }
        function close(_arg1:MouseEvent):void{
            MainViewController.getInstance().removePopups();
        }
        function show_popup(){
            MainViewController.getInstance().addPopup(this.popup);
        }
        public function show_offer(_arg1:MouseEvent):void{
            this.close(_arg1);
            External.openFreeItemOffer();
        }

    }
}//package com.viroxoty.fashionista.ui

