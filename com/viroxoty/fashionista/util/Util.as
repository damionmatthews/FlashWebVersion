// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.util.Util

package com.viroxoty.fashionista.util{
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.display.Loader;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.display.*;
    import flash.geom.*;
    import caurina.transitions.*;
    import com.adobe.serialization.json.*;

    public class Util {

        public static var tooltipClass:Class;

        public static function stacktrace(){
            var _local1:Error = new Error();
            Tracer.out(_local1.getStackTrace());
        }
        public static function random_between(_arg1:int, _arg2:int, _arg3:Boolean=false):Number{
            var _local4:int = (_arg2 - _arg1);
            var _local5:Number = (Math.random() * _local4);
            if (_arg3)
            {
                _local5 = int(_local5);
            };
            return ((_arg1 + _local5));
        }
        public static function clone(source:Object):Object{
            var clone:Object;
            var newSibling:Function = function (_arg1:Object){
                var _local2:*;
                var _local3:Class;
                if (_arg1)
                {
                    try
                    {
                        _local3 = (getDefinitionByName(getQualifiedClassName(_arg1)) as Class);
                        _local2 = new (_local3)();
                    } catch(e:Object)
                    {
                    };
                    return (_local2);
                };
                return (null);
            };
            if (source)
            {
                clone = newSibling(source);
                if (clone)
                {
                    copyData(source, clone);
                };
            };
            return (clone);
        }
        public static function copyData(_arg1:Object, _arg2:Object):void{
            var _local3:XML;
            var _local4:XML;
            if (((_arg1) && (_arg2)))
            {
                try
                {
                    _local3 = describeType(_arg1);
                    for each (_local4 in _local3.variable)
                    {
                        if (_arg2.hasOwnProperty(_local4.@name))
                        {
                            _arg2[_local4.@name] = _arg1[_local4.@name];
                        };
                    };
                    for each (_local4 in _local3.accessor)
                    {
                        if (_local4.@access == "readwrite")
                        {
                            if (_arg2.hasOwnProperty(_local4.@name))
                            {
                                _arg2[_local4.@name] = _arg1[_local4.@name];
                            };
                        };
                    };
                } catch(err:Object)
                {
                };
            };
        }
        public static function ordinalForInt(_arg1:int):String{
            switch (_arg1)
            {
                case 1:
                    return ("1st");
                case 2:
                    return ("2nd");
                case 3:
                    return ("3rd");
                default:
                    return ((_arg1 + "th"));
            };
        }
        public static function numberWithCommas(_arg1:int):String{
            var _local5:int;
            var _local2:String = String(_arg1);
            var _local3:int = _local2.length;
            if (_local3 < 4)
            {
                return (_local2);
            };
            var _local4:* = "";
            while (_local5 < _local3)
            {
                if (((_local3 - _local5) % 3) == 0)
                {
                    _local4 = (_local4 + ",");
                };
                _local4 = (_local4 + _local2.charAt(_local5));
                _local5++;
            };
            return (_local4);
        }
        public static function asJSON(_arg1:Object):String{
            return (Json.encode(_arg1));
        }
        public static function url_with_http(_arg1:String):String{
            return (_arg1.split("https").join("http"));
        }
        public static function fresh_url(_arg1:String):String{
            return (((_arg1 + "?") + Constants.START_TIME));
        }
        public static function replace(_arg1:String, _arg2:String, _arg3:String):String{
            if (_arg3.indexOf(_arg1) == -1)
            {
                throw (new Error(((("text " + _arg1) + " is not in ") + _arg3)));
            };
            return (_arg3.split(_arg1).join(_arg2));
        }
        public static function shortenTextWithEllipses(_arg1:String, _arg2:int):String{
            var _local3:int;
            var _local6:int;
            var _local7:int;
            if (_arg1.length <= _arg2)
            {
                return (_arg1);
            };
            var _local4:Array = _arg1.split(" ");
            var _local5:int = _local4.length;
            while (_local7 < _local5)
            {
                _local6 = (_local6 + _local4[_local7].length);
                if (_local6 > _arg2)
                {
                    _local3 = _local7;
                    break;
                };
                _local6 = (_local6 + 1);
                _local7++;
            };
            _local4.splice(_local7);
            return ((_local4.join(" ") + "..."));
        }
        public static function verticallyCenterText(_arg1:TextField){
            var _local2:Number = _arg1.height;
            _arg1.y = (_arg1.y + ((_local2 - _arg1.textHeight) / 2));
        }
        public static function setDefaultTextFormat(_arg1:TextField, _arg2:TextFormat){
            _arg1.defaultTextFormat = _arg2;
        }
        public static function negate(func:Function):Function{
            return (function (){
                return (!(func.apply(null, arguments)));
            });
        }
        public static function asArray(_arg1:Object, _arg2:int=0){
            var _local3:* = [];
            var _local4:int = _arg2;
            while (_local4 < _arg1.length)
            {
                _local3.push(_arg1[_local4]);
                _local4++;
            };
            return (_local3);
        }
        public static function partial(func:Function, ... rest):Function{
            var fixedArgs:Array;
            fixedArgs = rest;
            return (function (){
                return (func.apply(null, asArray(arguments).concat(fixedArgs)));
            });
        }
        public static function remove(a:Object, match:Object, prop:String=null){
            var index:int;
            var matches:Function;
            if (prop)
            {
                matches = function (_arg1:Object, _arg2:int, _arg3:Object):Boolean{
                    index = _arg2;
                    return ((_arg1[prop] == match));
                };
                if (a.some(matches) == false)
                {
                    return;
                };
            } else
            {
                index = a.indexOf(match);
            };
            if (index > -1)
            {
                a.splice(index, 1);
            };
        }
        public static function common(a:Object, b:Object, a_prop:String=null, b_prop:String=null):Object{
            var c:Object;
            var i:Object;
            var key:Object;
            if ((a is Vector))
            {
                c = a.filter(function (){
                    return (false);
                });
            } else
            {
                c = [];
            };
            var lookup:Object = make_lookup(a, a_prop);
            for each (i in b)
            {
                key = ((b_prop) ? i[b_prop] : i);
                if (lookup[key])
                {
                    c.push(lookup[key]);
                };
            };
            Tracer.out(("common: result is " + c));
            return (c);
        }
        public static function diff(a:Object, b:Object, a_prop:String=null, b_prop:String=null):Object{
            var c:Object;
            var i:Object;
            var key:Object;
            if ((a is Vector))
            {
                c = a.filter(function (){
                    return (false);
                });
            } else
            {
                c = [];
            };
            var lookup:Object = make_lookup(a, a_prop);
            for each (i in b)
            {
                key = ((b_prop) ? i[b_prop] : i);
                if (lookup[key])
                {
                    delete lookup[key];
                };
            };
            for each (i in lookup)
            {
                c.push(i);
            };
            Tracer.out(("common: result is " + c));
            return (c);
        }
        public static function merge(_arg1:Object, _arg2:Object, _arg3:String):void{
            var _local4:Object;
            var _local5:Object;
            var _local6:String;
            var _local7:Object = make_lookup(_arg1, _arg3);
            for each (_local4 in _arg2)
            {
                Tracer.out(("merge > " + _local4[_arg3]));
                if (_local7[_local4[_arg3]])
                {
                    _local5 = _local7[_local4[_arg3]];
                    for (_local6 in _local4)
                    {
                        Tracer.out(((("updating " + _local6) + " to ") + _local4[_local6]));
                        _local5[_local6] = _local4[_local6];
                    };
                };
            };
        }
        public static function random_item(_arg1:Object):Object{
            var _local2:int = Math.floor((Math.random() * _arg1.length));
            return (_arg1[_local2]);
        }
        public static function make_lookup(a:Object, prop:String=null, reference:Boolean=true):Object{
            var lookup:Object;
            var i:Object;
            var action:Function;
            action = function (_arg1:Object, _arg2:int, _arg3:Object):void{
                if (prop)
                {
                    lookup[_arg1[prop]] = ((reference) ? _arg1 : true);
                } else
                {
                    lookup[_arg1] = ((reference) ? _arg1 : true);
                };
            };
            lookup = new Object();
            a.forEach(action);
            return (lookup);
        }
        public static function fadeIn(_arg1:DisplayObject):void{
            Tweener.removeTweens(_arg1);
            if (_arg1.visible == false)
            {
                _arg1.alpha = 0;
                _arg1.visible = true;
            };
            Tweener.addTween(_arg1, {
                "alpha":1,
                "time":0.3
            });
        }
        public static function fadeOut(element:DisplayObject):void{
            var hide:Function;
            hide = function (){
                element.visible = false;
            };
            Tweener.removeTweens(element);
            Tweener.addTween(element, {
                "alpha":0,
                "time":0.3,
                "onComplete":hide
            });
        }
        public static function scaleAndCenterDisplayObject(_arg1:DisplayObject, _arg2:Number, _arg3:Number){
            var _local4:Number = (_arg2 / _arg1.width);
            var _local5:Number = (_arg3 / _arg1.height);
            var _local6:Number = Math.min(_local4, _local5);
            _arg1.scaleX = _local6;
            _arg1.scaleY = _local6;
            _arg1.x = ((_arg2 - _arg1.width) / 2);
            _arg1.y = ((_arg3 - _arg1.height) / 2);
            if ((_arg1 is Bitmap))
            {
                Bitmap(_arg1).smoothing = true;
            };
        }
        public static function getVisibleBoundingRectForAsset(_arg1:DisplayObject):Rectangle{
            var _local2:Rectangle = _arg1.getBounds(_arg1);
            var _local3:BitmapData = new BitmapData(int((_local2.width + 0.5)), int((_local2.height + 0.5)), true, 0);
            _local3.draw(_arg1, new Matrix(1, 0, 0, 1, -(_local2.x), -(_local2.y)));
            var _local4:Rectangle = _local3.getColorBoundsRect(0xFF000000, 0, false);
            _local4.offset(_local2.x, _local2.y);
            _local3.dispose();
            Tracer.out(((((((("getVisibleBoundingRectForAsset: was " + _local2.width) + ", ") + _local2.height) + ";  visibleBounds is ") + _local4.width) + ", ") + _local4.height));
            return (_local4);
        }
        public static function removeChildren(_arg1:DisplayObjectContainer):void{
            while (_arg1.numChildren > 0)
            {
                _arg1.removeChildAt(0);
            };
        }
        public static function stopClip(_arg1:DisplayObjectContainer):void{
            doForNestedClips(_arg1, "stop");
        }
        public static function playNestedClips(_arg1:DisplayObjectContainer):void{
            doForNestedClips(_arg1, "play");
        }
        static function doForNestedClips(_arg1:DisplayObjectContainer, _arg2:String):void{
            var _local3:DisplayObjectContainer;
            var _local4:int;
            var _local5:int;
            var _local6:*;
            if ((_arg1 is MovieClip))
            {
                _local6 = (_arg1 as MovieClip);
                var _local7 = _local6;
                (_local7[_arg2]());
            };
            if (_arg1.numChildren)
            {
                _local4 = _arg1.numChildren;
                while (_local5 < _local4)
                {
                    if ((_arg1.getChildAt(_local5) is DisplayObjectContainer))
                    {
                        _local3 = (_arg1.getChildAt(_local5) as DisplayObjectContainer);
                        if (_local3.numChildren)
                        {
                            doForNestedClips(_local3, _arg2);
                        } else
                        {
                            if ((_local3 is MovieClip))
                            {
                                _local6 = (_local3 as MovieClip);
                                _local7 = _local6;
                                (_local7[_arg2]());
                            };
                        };
                    };
                    _local5++;
                };
            };
        }
        public static function hideTips(_arg1:DisplayObjectContainer):void{
            var _local2:DisplayObject;
            var _local3:int;
            var _local4:int = _arg1.numChildren;
            while (_local3 < _local4)
            {
                if ((_arg1.getChildAt(_local3) is DisplayObject))
                {
                    _local2 = (_arg1.getChildAt(_local3) as DisplayObject);
                    if (_local2.name.indexOf("tip") > -1)
                    {
                        _local2.visible = false;
                    };
                };
                _local3++;
            };
        }
        public static function forTypeIn(_arg1:DisplayObjectContainer, _arg2:String, _arg3:Function){
            var _local4:DisplayObject;
            var _local5:int;
            var _local6:int = _arg1.numChildren;
            while (_local5 < _local6)
            {
                _local4 = _arg1.getChildAt(_local5);
                if (getQualifiedClassName(_local4).indexOf(_arg2) >= 0)
                {
                    (_arg3(_local4));
                };
                _local5++;
            };
        }
        public static function setTextFromData(_arg1:DisplayObjectContainer, _arg2:Object){
            var _local3:DisplayObject;
            var _local4:int;
            var _local5:String;
            var _local6:int = _arg1.numChildren;
            while (_local4 < _local6)
            {
                _local3 = _arg1.getChildAt(_local4);
                if ((_local3 is TextField))
                {
                    _local5 = _local3.name.split("_text").join("");
                    TextField(_local3).text = String(_arg2[_local5]);
                };
                _local4++;
            };
        }
        public static function simpleButton(_arg1:MovieClip, _arg2:Function, _arg3:Boolean=true):void{
            _arg1.buttonMode = true;
            _arg1.mouseChildren = false;
            _arg1.addEventListener(MouseEvent.CLICK, _arg2, false, 0, _arg3);
        }
        public static function simpleRolloverTip(_arg1:MovieClip, _arg2:DisplayObject):void{
            _arg1.tip = _arg2;
            _arg1.addEventListener(MouseEvent.ROLL_OVER, showSimpleTip, false, 0, true);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, hideSimpleTip, false, 0, true);
        }
        public static function showSimpleTip(_arg1:Event):void{
            _arg1.currentTarget.tip.visible = true;
        }
        public static function hideSimpleTip(_arg1:Event):void{
            _arg1.currentTarget.tip.visible = false;
        }
        public static function clearSimpleRolloverTip(_arg1:MovieClip):void{
            delete _arg1.tip;
            _arg1.removeEventListener(MouseEvent.ROLL_OVER, showSimpleTip);
            _arg1.removeEventListener(MouseEvent.ROLL_OUT, hideSimpleTip);
        }
        public static function setupButton(_arg1:MovieClip, _arg2:MovieClip=null, _arg3:Boolean=true):void{
            if (_arg2 == null)
            {
                _arg2 = _arg1;
            };
            _arg1.gotoAndStop(1);
            _arg2.gotoAndStop(1);
            _arg1.button_bg = _arg2;
            _arg1.selectable = _arg3;
            enable_button(_arg1);
            _arg1.startX = _arg1.x;
            _arg1.startY = _arg1.y;
            _arg1.addEventListener(MouseEvent.ROLL_OVER, show_button_over, false, 0, true);
            _arg1.addEventListener(MouseEvent.MOUSE_DOWN, show_button_down, false, 0, true);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, show_button_off, false, 0, true);
            _arg1.addEventListener(MouseEvent.MOUSE_UP, show_button_on, false, 0, true);
        }
        public static function disable_button(_arg1:MovieClip):void{
            _arg1.buttonMode = false;
            _arg1.mouseEnabled = false;
            _arg1.mouseChildren = false;
        }
        public static function enable_button(_arg1:MovieClip):void{
            _arg1.gotoAndStop(1);
            _arg1.buttonMode = true;
            _arg1.mouseEnabled = true;
            _arg1.mouseChildren = true;
        }
        static function show_button_over(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.button_bg.currentFrame == 3)
            {
                return;
            };
            Tracer.out(("  show_button_over : " + _local2));
            _local2.button_bg.gotoAndStop(2);
        }
        static function show_button_off(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            Tracer.out(("  show_button_off : " + _local2));
            _local2.x = _local2.startX;
            _local2.y = _local2.startY;
            if (_local2.button_bg.currentFrame == 3)
            {
                Tracer.out(("  show_button_off : not changing frame on selected " + _local2));
                return;
            };
            _local2.button_bg.gotoAndStop(1);
        }
        static function show_button_down(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            Tracer.out(("  show_button_down : " + _local2));
            _local2.x = (_local2.startX + 2);
            _local2.y = (_local2.startY + 2);
        }
        static function show_button_on(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.x != _local2.startX)
            {
                Tracer.out(("  show_button_on : " + _local2));
                _local2.x = _local2.startX;
                _local2.y = _local2.startY;
                if (_local2.selectable)
                {
                    _local2.button_bg.gotoAndStop(3);
                } else
                {
                    _local2.button_bg.gotoAndStop(2);
                };
            };
        }
        public static function create_tooltip(_arg1:String, _arg2:MovieClip, _arg3:String="left", _arg4:String="bottom", _arg5:MovieClip=null):void{
            var _local6:MovieClip;
            var _local7:int;
            if (_arg5 == null)
            {
                _arg5 = _arg2;
            };
            if (_arg5.tooltip == null)
            {
                _arg5.addEventListener(MouseEvent.ROLL_OVER, show_tooltip, false, 0, true);
                _arg5.addEventListener(MouseEvent.ROLL_OUT, hide_tooltip, false, 0, true);
            };
            if (_arg2.tooltip_index == null)
            {
                _arg2.tooltip_index = 0;
            };
            while (_local7 < _arg2.tooltip_index)
            {
                _local6 = (_arg2[("tooltip" + _local7)] as MovieClip);
                if ((((_local6.getTip() == _arg1)) && ((_local6.getOrientation() == (_arg3 + _arg4)))))
                {
                    _arg5.tooltip = _local6;
                    return;
                };
                _local7++;
            };
            _local6 = (new tooltipClass() as MovieClip);
            _local6.attach(_arg2, _arg5);
            _local6.defaultValuesForSkin4();
            _local6.setCustomVars({
                "Text":_arg1,
                "tipOrientationX":_arg3,
                "tipOrientationY":_arg4
            });
            _local6.name = ("tooltip" + _arg2.tooltip_index);
            _arg2[_local6.name] = _local6;
            _arg2.tooltip_index++;
            _arg5.tooltip = _local6;
        }
        public static function remove_tooltip(_arg1:MovieClip):void{
            if (_arg1.tooltip)
            {
                _arg1.tooltip.destroy();
                _arg1.tooltip = null;
                _arg1.removeEventListener(MouseEvent.ROLL_OVER, show_tooltip);
                _arg1.removeEventListener(MouseEvent.ROLL_OUT, hide_tooltip);
            };
        }
        static function show_tooltip(_arg1=null):void{
            var _local2:MovieClip = (MovieClip(_arg1.currentTarget).tooltip as MovieClip);
            _local2.show({});
        }
        static function hide_tooltip(_arg1=null):void{
            var _local2:MovieClip = (MovieClip(_arg1.currentTarget).tooltip as MovieClip);
            _local2.hide({});
        }
        public static function open_url(url:String, window:String="_blank"):void{
            var request:URLRequest = new URLRequest(url);
            try
            {
                navigateToURL(request, window);
            } catch(e:Error)
            {
                Tracer.out("Error occurred!");
            };
        }
        public static function get_app_domain(url:String, callback:Function){
            var asset_swf_loaded:Function;
            asset_swf_loaded = function (_arg1:Event):void{
                var _local2:ApplicationDomain = (_arg1.target as LoaderInfo).applicationDomain;
                callback(_local2);
            };
            Tracer.out(("Util > get_app_domain: " + url));
            var request:URLRequest = new URLRequest(url);
            var l:Loader = new Loader();
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, asset_swf_loaded);
            l.load(request);
        }

    }
}//package com.viroxoty.fashionista.util

