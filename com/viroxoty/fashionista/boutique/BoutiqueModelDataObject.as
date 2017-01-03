// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.BoutiqueModelDataObject

package com.viroxoty.fashionista.boutique{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.*;
    import __AS3__.vec.*;
    import flash.geom.*;

    public class BoutiqueModelDataObject {

        public var position:Point;
        public var scale:Number;
        public var items:Vector.<Item>;
        public var style:Object;

        public function BoutiqueModelDataObject(){
            this.position = new Point(278, 40);
            super();
        }
        public function parseItemData(_arg1:Array):void{
            var _local2:Item;
            var _local4:int;
            this.items = new Vector.<Item>();
            var _local3:int = _arg1.length;
            while (_local4 < _local3)
            {
                _local2 = new Item();
                _local2.parseServerJSON(_arg1[_local4]);
                this.items.push(_local2);
                _local4++;
            };
        }

    }
}//package com.viroxoty.fashionista.boutique

