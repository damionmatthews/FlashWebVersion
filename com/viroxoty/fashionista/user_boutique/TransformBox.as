// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.TransformBox

package com.viroxoty.fashionista.user_boutique{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.filters.DropShadowFilter;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;
    import flash.ui.*;

    public class TransformBox extends Sprite {

        private static const BOTTOM:int = 0;
        private static const TOP:int = 0;
        private static const LEFT:int = 1;
        private static const RIGHT:int = 1;

        private static var TRANSFORM_BOX_LINE_COLOR:uint = 0x333333;
        private static var TRANSFORM_BOX_LINE_WEIGHT:int = 0;
        private static var TRANSFORM_HANDLE_SIZE:int = 10;

        private var scalerSprite:Sprite;
        private var scaleCursor:MovieClip;
        private var deleteBtn:MovieClip;
        private var resetBtn:MovieClip;
        private var DELETE_BTN_SIZE:int = 15;
        private var DROP_SHADOW_DISTANCE:int = 1;
        private var DROP_SHADOW_ANGLE:int = 0;
        private var DROP_SHADOW_STRENGTH:Number = 0.5;
        private var isScaling:Boolean = false;
        var startHandleX:Number;
        var startHandleY:Number;
        private var canvas:Sprite;
        var viewController:UserBoutiqueObjectViewController;
        private var asset:Sprite;
        private var ratio:Number;
        private var transformVisibleBounds:Rectangle;
        private var mouseOffStage:Boolean;

        public function TransformBox(_arg1:UserBoutiqueObjectViewController, _arg2:Sprite){
            this.viewController = _arg1;
            this.asset = this.viewController.getAsset();
            this.ratio = this.viewController.getRatio();
            this.canvas = _arg2;
            this.viewController.addEventListener(UserBoutiqueObjectViewController.CHANGED_POSITION, this.updatePosition);
            this.viewController.addEventListener(UserBoutiqueObjectViewController.CHANGED_BOUNDS, this.updateBounds);
            this.viewController.addEventListener(UserBoutiqueObjectViewController.DESTROY, this.destroy);
        }
        public function init():void{
            this.initHandles();
            this.update();
        }
        public function destroy(_arg1:Event=null):void{
            trace("destroying transformBox");
            this.viewController.removeEventListener(UserBoutiqueObjectViewController.CHANGED_POSITION, this.updatePosition);
            this.viewController.removeEventListener(UserBoutiqueObjectViewController.CHANGED_BOUNDS, this.updateBounds);
            this.viewController.removeEventListener(UserBoutiqueObjectViewController.DESTROY, this.destroy);
            delete this[this];
        }
        public function update():void{
            this.updatePosition();
            this.drawBox();
        }
        function updateBounds(_arg1:Event=null):void{
            this.drawBox();
            trace(("TransformBox > updateBounds : ratio was " + this.ratio));
            this.ratio = Math.abs((this.transformVisibleBounds.width / this.transformVisibleBounds.height));
            trace(("TransformBox > updateBounds : ratio now " + this.ratio));
        }
        function updatePosition(_arg1:Event=null):void{
            var _local2:Point = this.canvas.globalToLocal(this.viewController.getOrigin());
            x = _local2.x;
            y = _local2.y;
            this.updateBoxUI();
        }
        private function clickDelete(_arg1:MouseEvent):void{
            if ((this.viewController is DecorViewController))
            {
                dispatchEvent(new Event(DecorManager.EVENT_REMOVE_DECOR));
            } else
            {
                if ((this.viewController is UserBoutiqueModelViewController))
                {
                    dispatchEvent(new Event(DecorManager.EVENT_REMOVE_MODEL));
                };
            };
        }
        private function clickReset(_arg1:MouseEvent):void{
            dispatchEvent(new Event(DecorManager.EVENT_RESET_MODEL));
        }
        private function scaleClipStart(_arg1:MouseEvent):void{
            var _local2:Sprite;
            var _local3:int;
            if (this.isScaling)
            {
                return;
            };
            this.isScaling = true;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.scaleClip);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this.scaleClipStop);
            while (_local3 < 4)
            {
                _local2 = (this.scalerSprite.getChildAt(_local3) as Sprite);
                if (_local2.hitTestPoint(_arg1.stageX, _arg1.stageY, true))
                {
                    this.startHandleX = _local2.x;
                    this.startHandleY = _local2.y;
                };
                _local3++;
            };
        }
        private function scaleClip(_arg1:MouseEvent):void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number = this.mouseX;
            var _local6:Number = this.mouseY;
            var _local7:int = ((((_local5 > 0))==(_local6 > 0)) ? 1 : -1);
            _local4 = Math.abs((this.startHandleX / this.startHandleY));
            if (Math.abs((_local5 / _local4)) < Math.abs(_local6))
            {
                _local2 = _local5;
                _local3 = ((_local7 * _local5) / _local4);
            } else
            {
                _local2 = ((_local7 * _local6) * _local4);
                _local3 = _local6;
            };
            var _local8:Number = (_local2 / this.startHandleX);
            var _local9:Number = Math.abs((_local3 / this.startHandleY));
            this.viewController.adjustAssetScale(_local8, _local9);
            this.drawBox();
            _arg1.updateAfterEvent();
        }
        private function scaleClipStop(_arg1=null):void{
            this.isScaling = false;
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.scaleClip);
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.scaleClipStop);
            this.viewController.setScale();
        }
        private function drawBox(_arg1:Event=null):void{
            var _local2:Point;
            var _local3:DisplayObject;
            graphics.clear();
            graphics.lineStyle(TRANSFORM_BOX_LINE_WEIGHT, TRANSFORM_BOX_LINE_COLOR);
            var _local4:Rectangle = this.getTransformVisibleBoundsForAsset(this.asset);
            var _local5:Object = {};
            _local5.bounds0 = new Point(_local4.x, _local4.y);
            _local5.bounds1 = new Point((_local4.x + _local4.width), _local4.y);
            _local5.bounds2 = new Point(_local4.x, (_local4.y + _local4.height));
            _local5.bounds3 = new Point((_local4.x + _local4.width), (_local4.y + _local4.height));
            var _local6:* = 0;
            while (_local6 < 4)
            {
                _local2 = _local5[("bounds" + _local6)];
                _local3 = this.scalerSprite.getChildAt(_local6);
                _local3.x = _local2.x;
                _local3.y = _local2.y;
                _local6++;
            };
            var _local7:DisplayObject = this.scalerSprite.getChildAt(0);
            var _local8:DisplayObject = this.scalerSprite.getChildAt(3);
            var _local9:Number = _local7.x;
            var _local10:Number = _local8.x;
            var _local11:Number = (_local10 - _local9);
            var _local12:Number = _local7.y;
            var _local13:Number = _local8.y;
            var _local14:Number = (_local13 - _local12);
            graphics.drawRect(_local9, _local12, _local11, _local14);
            this.drawButtons(new Rectangle(_local9, _local12, _local11, _local14));
        }
        private function updateBoxUI(){
            var _local1:DisplayObject = this.scalerSprite.getChildAt(0);
            var _local2:DisplayObject = this.scalerSprite.getChildAt(3);
            var _local3:Number = _local1.x;
            var _local4:Number = _local2.x;
            var _local5:Number = (_local4 - _local3);
            var _local6:Number = _local1.y;
            var _local7:Number = _local2.y;
            var _local8:Number = (_local7 - _local6);
            this.drawButtons(new Rectangle(_local3, _local6, _local5, _local8));
        }
        private function drawButtons(_arg1:Rectangle){
            if (this.deleteBtn)
            {
                this.positionButtonOnscreen(this.deleteBtn, _arg1);
            };
            if (this.resetBtn)
            {
                this.positionButtonOnscreen(this.resetBtn, _arg1);
            };
            if (((this.deleteBtn) && (this.resetBtn)))
            {
                if (this.deleteBtn.line == BOTTOM)
                {
                    this.deleteBtn.x = (this.deleteBtn.x - (this.deleteBtn.width / 2));
                    this.resetBtn.x = (this.resetBtn.x + (this.resetBtn.width / 2));
                } else
                {
                    this.deleteBtn.y = (this.deleteBtn.y - (this.deleteBtn.height / 2));
                    this.resetBtn.y = (this.resetBtn.y + (this.resetBtn.height / 2));
                };
            };
        }
        private function positionButtonOnscreen(_arg1:MovieClip, _arg2:Rectangle):void{
            var _local3:*;
            var _local4:*;
            var _local5:* = (-(this.viewController.x) + (this.DELETE_BTN_SIZE / 2));
            var _local6:* = ((_local5 + Constants.SCREEN_WIDTH) - this.DELETE_BTN_SIZE);
            var _local7:* = (-(this.viewController.y) + (this.DELETE_BTN_SIZE / 2));
            var _local8:* = ((_local7 + Constants.GAME_SCREEN_HEIGHT) - (this.DELETE_BTN_SIZE * 3));
            Tracer.out(((((((("positionButtonOnscreen > min_x = " + _local5) + ", max_x = ") + _local6) + ", min_y = ") + _local7) + ", max_y = ") + _local8));
            if (_arg2.bottom <= _local8)
            {
                _local4 = _arg2.bottom;
                _local3 = (_arg2.left + (_arg2.width / 2));
                _arg1.line = BOTTOM;
            } else
            {
                if (_arg2.top >= _local7)
                {
                    _local4 = _arg2.top;
                    _local3 = (_arg2.left + (_arg2.width / 2));
                    _arg1.line = TOP;
                } else
                {
                    if (_arg2.left >= _local5)
                    {
                        _local3 = _arg2.left;
                        _local4 = (_arg2.top + (_arg2.height / 2));
                        _arg1.line = LEFT;
                    } else
                    {
                        if (_arg2.right <= _local6)
                        {
                            _local3 = _arg2.right;
                            _local4 = (_arg2.top + (_arg2.height / 2));
                            _arg1.line = RIGHT;
                        };
                    };
                };
            };
            _local3 = Math.max(_local5, _local3);
            _local3 = Math.min(_local6, _local3);
            _local4 = Math.max(_local7, _local4);
            _local4 = Math.min(_local8, _local4);
            _arg1.x = _local3;
            _arg1.y = _local4;
        }
        private function initHandles():void{
            var _local1:BitmapData;
            var _local2:Bitmap;
            var _local3:MovieClip;
            var _local4:Sprite;
            var _local5:DecorManager;
            var _local6:int;
            this.scalerSprite = new Sprite();
            while (_local6 < 4)
            {
                _local1 = new BitmapData(TRANSFORM_HANDLE_SIZE, TRANSFORM_HANDLE_SIZE, false, 0xFF000000);
                _local2 = new Bitmap(_local1);
                _local2.x = (-(TRANSFORM_HANDLE_SIZE) / 2);
                _local2.y = (-(TRANSFORM_HANDLE_SIZE) / 2);
                _local2.visible = false;
                _local3 = (MainViewController.getInstance().get_game_asset("transformer_handle") as MovieClip);
                _local4 = new Sprite();
                _local4.addChild(_local2);
                _local4.addChild(_local3);
                this.scalerSprite.addChild(_local4);
                _local6++;
            };
            this.scalerSprite.addEventListener(MouseEvent.MOUSE_OVER, this.showScaleCursor);
            addChild(this.scalerSprite);
            if ((this.viewController is DecorViewController))
            {
                this.deleteBtn = (MainViewController.getInstance().get_game_asset("delete_btn") as MovieClip);
                this.deleteBtn.buttonMode = true;
                this.deleteBtn.addEventListener(MouseEvent.CLICK, this.clickDelete, false, 0, true);
                addChild(this.deleteBtn);
            };
            if ((this.viewController is UserBoutiqueModelViewController))
            {
                this.resetBtn = (MainViewController.getInstance().get_game_asset("reset_btn") as MovieClip);
                this.resetBtn.buttonMode = true;
                this.resetBtn.addEventListener(MouseEvent.CLICK, this.clickReset, false, 0, true);
                addChild(this.resetBtn);
                _local5 = DecorManager.getInstance();
                if (_local5.boutique.floors[_local5.currentFloor].both_models_visible)
                {
                    this.deleteBtn = (MainViewController.getInstance().get_game_asset("delete_btn") as MovieClip);
                    this.deleteBtn.buttonMode = true;
                    this.deleteBtn.addEventListener(MouseEvent.CLICK, this.clickDelete, false, 0, true);
                    addChild(this.deleteBtn);
                };
            };
        }
        private function showScaleCursor(_arg1:MouseEvent):void{
            this.viewController.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.updateScaleCursor);
            Mouse.hide();
            this.scaleCursor = (MainViewController.getInstance().get_game_asset("scale_cursor") as MovieClip);
            var _local2:DropShadowFilter = new DropShadowFilter();
            _local2.distance = this.DROP_SHADOW_DISTANCE;
            _local2.angle = this.DROP_SHADOW_ANGLE;
            _local2.strength = this.DROP_SHADOW_STRENGTH;
            var _local3:Array = new Array(_local2);
            this.scaleCursor.filters = _local3;
            this.viewController.stage.addChild(this.scaleCursor);
            this.scaleCursor.addEventListener(MouseEvent.MOUSE_DOWN, this.scaleClipStart);
            this.scaleCursor.x = _arg1.stageX;
            this.scaleCursor.y = _arg1.stageY;
            if ((this.viewController.mouseX * this.viewController.mouseY) < 0)
            {
                this.scaleCursor.scaleX = -1;
            } else
            {
                this.scaleCursor.scaleX = 1;
            };
            this.scalerSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.showScaleCursor);
        }
        private function updateScaleCursor(_arg1:MouseEvent):void{
            this.scaleCursor.x = _arg1.stageX;
            this.scaleCursor.y = _arg1.stageY;
            if ((this.viewController.mouseX * this.viewController.mouseY) < 0)
            {
                this.scaleCursor.scaleX = -1;
            } else
            {
                this.scaleCursor.scaleX = 1;
            };
            if (((!((this.scalerSprite.hitTestPoint(_arg1.stageX, _arg1.stageY, true) == true))) && (!((this.isScaling == true)))))
            {
                this.hideScaleCursor();
            };
        }
        private function hideScaleCursor():void{
            this.viewController.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateScaleCursor);
            this.scalerSprite.addEventListener(MouseEvent.MOUSE_OVER, this.showScaleCursor);
            this.viewController.stage.removeChild(this.scaleCursor);
            this.scaleCursor = null;
            Mouse.show();
        }
        function getTransformVisibleBoundsForAsset(_arg1:Sprite):Rectangle{
            var _local2:* = Util.getVisibleBoundingRectForAsset(_arg1);
            var _local3:Point = _arg1.localToGlobal(new Point(_local2.x, _local2.y));
            var _local4:Point = _arg1.localToGlobal(new Point((_local2.x + _local2.width), (_local2.y + _local2.height)));
            var _local5:Point = this.globalToLocal(_local3);
            var _local6:Point = this.globalToLocal(_local4);
            this.transformVisibleBounds = new Rectangle(_local5.x, _local5.y, (_local6.x - _local5.x), (_local6.y - _local5.y));
            return (this.transformVisibleBounds);
        }

    }
}//package com.viroxoty.fashionista.user_boutique

