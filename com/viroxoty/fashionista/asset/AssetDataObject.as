// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.asset.AssetDataObject

package com.viroxoty.fashionista.asset{
    public dynamic class AssetDataObject {

        public var url:String;
        public var name:String;
        public var assetType:String = "assets";
        public var category:String;
        public var index:int;
        public var format:String = "swf";

        public function parseURL(_arg1:String):void{
            this.url = _arg1;
            this.makeNameFromURL();
            this.makeFormatFromName();
        }
        public function makeNameFromURL():void{
            var _local1:Array = this.url.split("/");
            this.name = _local1[(_local1.length - 1)];
        }
        public function makeFormatFromName():void{
            this.format = this.name.split(".")[1];
        }

    }
}//package com.viroxoty.fashionista.asset

