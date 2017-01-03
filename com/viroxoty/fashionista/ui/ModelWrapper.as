// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.ModelWrapper

package com.viroxoty.fashionista.ui{
    import flash.display.DisplayObjectContainer;
    import com.viroxoty.fashionista.boutique.BoutiqueModelDataObject;
    import com.viroxoty.fashionista.boutique.BoutiqueModel;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Styles;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class ModelWrapper {

        var container:DisplayObjectContainer;

        public function ModelWrapper(_arg1:Vector.<Item>, _arg2:Styles, _arg3:DisplayObjectContainer){
            var _local4:BoutiqueModelDataObject;
            super();
            this.container = _arg3;
            _local4 = new BoutiqueModelDataObject();
            _local4.items = _arg1;
            _local4.style = _arg2;
            var _local5:BoutiqueModel = new BoutiqueModel();
            _local5.init();
            _local5.get_boutique_model_for(this, _local4);
        }
        public function set_boutique_model(_arg1:MovieClip, _arg2:BoutiqueModelDataObject, _arg3:BoutiqueModel):void{
            var _local4:Item;
            var _local5:String;
            var _local6:String;
            var _local9:int;
            if ((((this.container == null)) || ((this.container.parent == null))))
            {
                return;
            };
            this.container.alpha = 0;
            this.container.addChild(_arg1);
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
            if ((((this.container == null)) || ((this.container.parent == null))))
            {
                return;
            };
            _arg1.target.removeEventListener("model_ready", this.model_ready);
            Util.fadeIn(this.container);
        }

    }
}//package com.viroxoty.fashionista.ui

