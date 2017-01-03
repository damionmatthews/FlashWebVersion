// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Item

package com.viroxoty.fashionista.data{
    import com.viroxoty.fashionista.util.*;

    public dynamic class Item extends PurchasableObject {

        public var category:String;
        public var closet_category:int;
        public var closet_category_name:String;
        public var model_png_url:String;
        public var png:String;

        public static function parseUserBoutiqueModelItem(_arg1:Object):Item{
            var _local2:Item = new (Item)();
            _local2.category = _arg1.Cat_Name.toLowerCase();
            _local2.swf = (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.dressuplook_swf);
            _local2.id = _arg1.Item_ID;
            if (_arg1.Item_Name)
            {
                _local2.name = _arg1.Item_Name;
                _local2.description = _arg1.Item_Desc;
                _local2.price = _arg1.cost;
                _local2.cost_fcash = _local2.price;
                _local2.cost_fbcredits = Constants.convertFcashToFBCredits(_local2.price);
                _local2.fb_credits = (int(_arg1.fb_credits) == 1);
                _local2.level = _arg1.level;
            };
            return (_local2);
        }

        public function parseServerItem(_arg1:Object):Boolean{
            if (_arg1.Cat_Name == null)
            {
                return (false);
            };
            id = _arg1.Item_ID;
            name = _arg1.Item_Name;
            swf = (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.dressuplook_swf);
            this.category = _arg1.Cat_Name.toLowerCase();
            this.closet_category = _arg1.Closet_category_ID;
            return (true);
        }
        public function parseFreeItem(_arg1:Object):void{
            id = _arg1.id;
            name = _arg1.title;
            swf = (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.dressuplook_swf);
            this.category = _arg1.Cat_Name.toLowerCase();
            this.closet_category = _arg1.Closet_category_ID;
            this.model_png_url = ((Constants.SERVER_IMAGES + "free_offer_items/") + _arg1.png);
            this.png = ((Constants.SERVER_IMAGES + "product_png/") + _arg1.png);
        }
        public function parseServerXML(_arg1:XML, _arg2:Boolean=false):void{
            id = int(_arg1.ID);
            name = _arg1.TITLE;
            fb_credits = (_arg1.FB_CREDITS == "1");
            swf = _arg1.SWF;
            if (((_arg2) && (fb_credits)))
            {
                this.png = (Constants.SERVER_ITEM_IMAGES + swf.split("swf").join("png"));
            };
            if (swf.indexOf("http") == -1)
            {
                swf = (Constants.SERVER_BOUTIQUE_ITEMS + swf);
            };
            this.closet_category = int(_arg1.CLOSET_CATEGORY_ID);
            this.category = _arg1.NAME.toLowerCase();
            price = int(_arg1.PRICE);
            cost_fcash = price;
            cost_fbcredits = Constants.convertFcashToFBCredits(price);
            level = _arg1.LEVEL;
            description = _arg1.DESC;
        }
        public function parseServerJSON(_arg1:Object):void{
            id = int(_arg1.id);
            name = _arg1.title;
            this.category = _arg1.category.toLowerCase();
            swf = (((_arg1.swf.indexOf("http"))==-1) ? (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.swf) : _arg1.swf);
            this.closet_category = int(_arg1.closet_category);
            price = _arg1.price;
            cost_fcash = price;
            cost_fbcredits = Constants.convertFcashToFBCredits(price);
            level = _arg1.level;
            description = _arg1.description;
            fb_credits = (_arg1.fb_credits == "1");
            restrictions = (((_arg1.restrictions)==null) ? null : _arg1.restrictions.split(","));
        }
        public function parseRunwayXML(_arg1:XML):void{
            id = int(_arg1.@id);
            swf = (((_arg1.swf.indexOf("http"))==-1) ? (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.swf) : _arg1.swf);
            this.category = _arg1.category.toString().toLowerCase();
            this.closet_category = int(_arg1.closet_category_id);
            name = _arg1.title;
            description = _arg1.description;
            price = int(_arg1.price);
            cost_fcash = price;
            cost_fbcredits = Constants.convertFcashToFBCredits(price);
            fb_credits = (_arg1.fb_credits == "1");
            level = int(_arg1.level);
        }
        public function parseMessageItem(_arg1:Object):void{
            id = int(_arg1.Item_ID);
            name = _arg1.Item_Name;
            price = int(_arg1.cost);
            cost_fcash = price;
            cost_fbcredits = Constants.convertFcashToFBCredits(price);
            description = _arg1.Item_Desc;
        }
        public function addAcceptGiftParams(_arg1:Object):void{
            this.category = _arg1.Cat_Name.toLowerCase();
            swf = (Constants.SERVER_BOUTIQUE_ITEMS + _arg1.dressuplook_swf);
            this.closet_category = int(_arg1.Closet_category_ID);
        }
        public function addThankYouGiftParams(_arg1:Object):void{
            name = _arg1.Item_Name;
            this.addAcceptGiftParams(_arg1);
            Tracer.out(("Item > addThankYouGiftParams : " + this.toString()));
        }
        public function toString():String{
            return (((((((((((((((((((id + " : ") + name) + " : ") + swf) + " : ") + this.category) + " : ") + this.closet_category) + " : ") + this.closet_category_name) + " : ") + price) + " : ") + fb_credits) + " : ") + level) + " : ") + description));
        }

    }
}//package com.viroxoty.fashionista.data

