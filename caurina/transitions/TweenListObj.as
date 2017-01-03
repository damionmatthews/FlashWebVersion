// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.TweenListObj

package caurina.transitions{
    public class TweenListObj {

        public var scope:Object;
        public var properties:Object;
        public var timeStart:Number;
        public var timeComplete:Number;
        public var useFrames:Boolean;
        public var transition:Function;
        public var transitionParams:Object;
        public var onStart:Function;
        public var onUpdate:Function;
        public var onComplete:Function;
        public var onOverwrite:Function;
        public var onError:Function;
        public var onStartParams:Array;
        public var onUpdateParams:Array;
        public var onCompleteParams:Array;
        public var onOverwriteParams:Array;
        public var onStartScope:Object;
        public var onUpdateScope:Object;
        public var onCompleteScope:Object;
        public var onOverwriteScope:Object;
        public var onErrorScope:Object;
        public var rounded:Boolean;
        public var isPaused:Boolean;
        public var timePaused:Number;
        public var isCaller:Boolean;
        public var count:Number;
        public var timesCalled:Number;
        public var waitFrames:Boolean;
        public var skipUpdates:Number;
        public var updatesSkipped:Number;
        public var hasStarted:Boolean;

        public function TweenListObj(_arg1:Object, _arg2:Number, _arg3:Number, _arg4:Boolean, _arg5:Function, _arg6:Object){
            this.scope = _arg1;
            this.timeStart = _arg2;
            this.timeComplete = _arg3;
            this.useFrames = _arg4;
            this.transition = _arg5;
            this.transitionParams = _arg6;
            this.properties = new Object();
            this.isPaused = false;
            this.timePaused = undefined;
            this.isCaller = false;
            this.updatesSkipped = 0;
            this.timesCalled = 0;
            this.skipUpdates = 0;
            this.hasStarted = false;
        }
        public static function makePropertiesChain(_arg1:Object):Object{
            var _local2:Object;
            var _local3:Object;
            var _local4:Object;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Object = _arg1.base;
            if (_local8)
            {
                _local2 = {};
                if ((_local8 is Array))
                {
                    _local3 = [];
                    _local7 = 0;
                    while (_local7 < _local8.length)
                    {
                        _local3.push(_local8[_local7]);
                        _local7++;
                    };
                } else
                {
                    _local3 = [_local8];
                };
                _local3.push(_arg1);
                _local5 = _local3.length;
                _local6 = 0;
                while (_local6 < _local5)
                {
                    if (_local3[_local6]["base"])
                    {
                        _local4 = AuxFunctions.concatObjects(makePropertiesChain(_local3[_local6]["base"]), _local3[_local6]);
                    } else
                    {
                        _local4 = _local3[_local6];
                    };
                    _local2 = AuxFunctions.concatObjects(_local2, _local4);
                    _local6++;
                };
                if (_local2["base"])
                {
                    delete _local2["base"];
                };
                return (_local2);
            };
            return (_arg1);
        }

        public function clone(_arg1:Boolean):TweenListObj{
            var _local2:String;
            var _local3:TweenListObj = new TweenListObj(this.scope, this.timeStart, this.timeComplete, this.useFrames, this.transition, this.transitionParams);
            _local3.properties = new Array();
            for (_local2 in this.properties)
            {
                _local3.properties[_local2] = this.properties[_local2].clone();
            };
            _local3.skipUpdates = this.skipUpdates;
            _local3.updatesSkipped = this.updatesSkipped;
            if (!_arg1)
            {
                _local3.onStart = this.onStart;
                _local3.onUpdate = this.onUpdate;
                _local3.onComplete = this.onComplete;
                _local3.onOverwrite = this.onOverwrite;
                _local3.onError = this.onError;
                _local3.onStartParams = this.onStartParams;
                _local3.onUpdateParams = this.onUpdateParams;
                _local3.onCompleteParams = this.onCompleteParams;
                _local3.onOverwriteParams = this.onOverwriteParams;
                _local3.onStartScope = this.onStartScope;
                _local3.onUpdateScope = this.onUpdateScope;
                _local3.onCompleteScope = this.onCompleteScope;
                _local3.onOverwriteScope = this.onOverwriteScope;
                _local3.onErrorScope = this.onErrorScope;
            };
            _local3.rounded = this.rounded;
            _local3.isPaused = this.isPaused;
            _local3.timePaused = this.timePaused;
            _local3.isCaller = this.isCaller;
            _local3.count = this.count;
            _local3.timesCalled = this.timesCalled;
            _local3.waitFrames = this.waitFrames;
            _local3.hasStarted = this.hasStarted;
            return (_local3);
        }
        public function toString():String{
            var _local1:String;
            var _local2:* = "\n[TweenListObj ";
            _local2 = (_local2 + ("scope:" + String(this.scope)));
            _local2 = (_local2 + ", properties:");
            var _local3:Boolean = true;
            for (_local1 in this.properties)
            {
                if (!_local3)
                {
                    _local2 = (_local2 + ",");
                };
                _local2 = (_local2 + ("[name:" + this.properties[_local1].name));
                _local2 = (_local2 + (",valueStart:" + this.properties[_local1].valueStart));
                _local2 = (_local2 + (",valueComplete:" + this.properties[_local1].valueComplete));
                _local2 = (_local2 + "]");
                _local3 = false;
            };
            _local2 = (_local2 + (", timeStart:" + String(this.timeStart)));
            _local2 = (_local2 + (", timeComplete:" + String(this.timeComplete)));
            _local2 = (_local2 + (", useFrames:" + String(this.useFrames)));
            _local2 = (_local2 + (", transition:" + String(this.transition)));
            _local2 = (_local2 + (", transitionParams:" + String(this.transitionParams)));
            if (this.skipUpdates)
            {
                _local2 = (_local2 + (", skipUpdates:" + String(this.skipUpdates)));
            };
            if (this.updatesSkipped)
            {
                _local2 = (_local2 + (", updatesSkipped:" + String(this.updatesSkipped)));
            };
            if (Boolean(this.onStart))
            {
                _local2 = (_local2 + (", onStart:" + String(this.onStart)));
            };
            if (Boolean(this.onUpdate))
            {
                _local2 = (_local2 + (", onUpdate:" + String(this.onUpdate)));
            };
            if (Boolean(this.onComplete))
            {
                _local2 = (_local2 + (", onComplete:" + String(this.onComplete)));
            };
            if (Boolean(this.onOverwrite))
            {
                _local2 = (_local2 + (", onOverwrite:" + String(this.onOverwrite)));
            };
            if (Boolean(this.onError))
            {
                _local2 = (_local2 + (", onError:" + String(this.onError)));
            };
            if (this.onStartParams)
            {
                _local2 = (_local2 + (", onStartParams:" + String(this.onStartParams)));
            };
            if (this.onUpdateParams)
            {
                _local2 = (_local2 + (", onUpdateParams:" + String(this.onUpdateParams)));
            };
            if (this.onCompleteParams)
            {
                _local2 = (_local2 + (", onCompleteParams:" + String(this.onCompleteParams)));
            };
            if (this.onOverwriteParams)
            {
                _local2 = (_local2 + (", onOverwriteParams:" + String(this.onOverwriteParams)));
            };
            if (this.onStartScope)
            {
                _local2 = (_local2 + (", onStartScope:" + String(this.onStartScope)));
            };
            if (this.onUpdateScope)
            {
                _local2 = (_local2 + (", onUpdateScope:" + String(this.onUpdateScope)));
            };
            if (this.onCompleteScope)
            {
                _local2 = (_local2 + (", onCompleteScope:" + String(this.onCompleteScope)));
            };
            if (this.onOverwriteScope)
            {
                _local2 = (_local2 + (", onOverwriteScope:" + String(this.onOverwriteScope)));
            };
            if (this.onErrorScope)
            {
                _local2 = (_local2 + (", onErrorScope:" + String(this.onErrorScope)));
            };
            if (this.rounded)
            {
                _local2 = (_local2 + (", rounded:" + String(this.rounded)));
            };
            if (this.isPaused)
            {
                _local2 = (_local2 + (", isPaused:" + String(this.isPaused)));
            };
            if (this.timePaused)
            {
                _local2 = (_local2 + (", timePaused:" + String(this.timePaused)));
            };
            if (this.isCaller)
            {
                _local2 = (_local2 + (", isCaller:" + String(this.isCaller)));
            };
            if (this.count)
            {
                _local2 = (_local2 + (", count:" + String(this.count)));
            };
            if (this.timesCalled)
            {
                _local2 = (_local2 + (", timesCalled:" + String(this.timesCalled)));
            };
            if (this.waitFrames)
            {
                _local2 = (_local2 + (", waitFrames:" + String(this.waitFrames)));
            };
            if (this.hasStarted)
            {
                _local2 = (_local2 + (", hasStarted:" + String(this.hasStarted)));
            };
            _local2 = (_local2 + "]\n");
            return (_local2);
        }

    }
}//package caurina.transitions

