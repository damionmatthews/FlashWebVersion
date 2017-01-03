// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.Tweener

package caurina.transitions{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.*;
    import flash.utils.*;
    import flash.display.*;

    public class Tweener {

        private static var __tweener_controller__:MovieClip;
        private static var _engineExists:Boolean = false;
        private static var _inited:Boolean = false;
        private static var _currentTime:Number;
        private static var _currentTimeFrame:Number;
        private static var _tweenList:Array;
        private static var _timeScale:Number = 1;
        private static var _transitionList:Object;
        private static var _specialPropertyList:Object;
        private static var _specialPropertyModifierList:Object;
        private static var _specialPropertySplitterList:Object;
        public static var autoOverwrite:Boolean = true;

        public function Tweener(){
            trace("Tweener is a static class and should not be instantiated.");
        }
        public static function addTween(_arg1:Object=null, _arg2:Object=null):Boolean{
            var _local3:Number;
            var _local4:Number;
            var _local5:String;
            var _local6:Array;
            var _local7:Function;
            var _local8:Object;
            var _local9:TweenListObj;
            var _local10:Number;
            var _local11:Array;
            var _local12:Array;
            var _local13:Array;
            var _local14:String;
            if (!Boolean(_arg1))
            {
                return (false);
            };
            if ((_arg1 is Array))
            {
                _local6 = _arg1.concat();
            } else
            {
                _local6 = [_arg1];
            };
            var _local15:Object = TweenListObj.makePropertiesChain(_arg2);
            if (!_inited)
            {
                init();
            };
            if (((!(_engineExists)) || (!(Boolean(__tweener_controller__)))))
            {
                startEngine();
            };
            var _local16:Number = ((isNaN(_local15.time)) ? 0 : _local15.time);
            var _local17:Number = ((isNaN(_local15.delay)) ? 0 : _local15.delay);
            var _local18:Array = new Array();
            var _local19:Object = {
                "overwrite":true,
                "time":true,
                "delay":true,
                "useFrames":true,
                "skipUpdates":true,
                "transition":true,
                "transitionParams":true,
                "onStart":true,
                "onUpdate":true,
                "onComplete":true,
                "onOverwrite":true,
                "onError":true,
                "rounded":true,
                "onStartParams":true,
                "onUpdateParams":true,
                "onCompleteParams":true,
                "onOverwriteParams":true,
                "onStartScope":true,
                "onUpdateScope":true,
                "onCompleteScope":true,
                "onOverwriteScope":true,
                "onErrorScope":true
            };
            var _local20:Object = new Object();
            for (_local5 in _local15)
            {
                if (!_local19[_local5])
                {
                    if (_specialPropertySplitterList[_local5])
                    {
                        _local11 = _specialPropertySplitterList[_local5].splitValues(_local15[_local5], _specialPropertySplitterList[_local5].parameters);
                        _local3 = 0;
                        while (_local3 < _local11.length)
                        {
                            if (_specialPropertySplitterList[_local11[_local3].name])
                            {
                                _local12 = _specialPropertySplitterList[_local11[_local3].name].splitValues(_local11[_local3].value, _specialPropertySplitterList[_local11[_local3].name].parameters);
                                _local4 = 0;
                                while (_local4 < _local12.length)
                                {
                                    _local18[_local12[_local4].name] = {
                                        "valueStart":undefined,
                                        "valueComplete":_local12[_local4].value,
                                        "arrayIndex":_local12[_local4].arrayIndex,
                                        "isSpecialProperty":false
                                    };
                                    _local4++;
                                };
                            } else
                            {
                                _local18[_local11[_local3].name] = {
                                    "valueStart":undefined,
                                    "valueComplete":_local11[_local3].value,
                                    "arrayIndex":_local11[_local3].arrayIndex,
                                    "isSpecialProperty":false
                                };
                            };
                            _local3++;
                        };
                    } else
                    {
                        if (_specialPropertyModifierList[_local5] != undefined)
                        {
                            _local13 = _specialPropertyModifierList[_local5].modifyValues(_local15[_local5]);
                            _local3 = 0;
                            while (_local3 < _local13.length)
                            {
                                _local20[_local13[_local3].name] = {
                                    "modifierParameters":_local13[_local3].parameters,
                                    "modifierFunction":_specialPropertyModifierList[_local5].getValue
                                };
                                _local3++;
                            };
                        } else
                        {
                            _local18[_local5] = {
                                "valueStart":undefined,
                                "valueComplete":_local15[_local5]
                            };
                        };
                    };
                };
            };
            for (_local5 in _local18)
            {
                if (_specialPropertyList[_local5] != undefined)
                {
                    _local18[_local5].isSpecialProperty = true;
                } else
                {
                    if (_local6[0][_local5] == undefined)
                    {
                        printError((((("The property '" + _local5) + "' doesn't seem to be a normal object property of ") + String(_local6[0])) + " or a registered special property."));
                    };
                };
            };
            for (_local5 in _local20)
            {
                if (_local18[_local5] != undefined)
                {
                    _local18[_local5].modifierParameters = _local20[_local5].modifierParameters;
                    _local18[_local5].modifierFunction = _local20[_local5].modifierFunction;
                };
            };
            if (typeof(_local15.transition) == "string")
            {
                _local14 = _local15.transition.toLowerCase();
                _local7 = _transitionList[_local14];
            } else
            {
                _local7 = _local15.transition;
            };
            if (!Boolean(_local7))
            {
                _local7 = _transitionList["easeoutexpo"];
            };
            _local3 = 0;
            while (_local3 < _local6.length)
            {
                _local8 = new Object();
                for (_local5 in _local18)
                {
                    _local8[_local5] = new PropertyInfoObj(_local18[_local5].valueStart, _local18[_local5].valueComplete, _local18[_local5].valueComplete, _local18[_local5].arrayIndex, {}, _local18[_local5].isSpecialProperty, _local18[_local5].modifierFunction, _local18[_local5].modifierParameters);
                };
                if (_local15.useFrames == true)
                {
                    _local9 = new TweenListObj(_local6[_local3], (_currentTimeFrame + (_local17 / _timeScale)), (_currentTimeFrame + ((_local17 + _local16) / _timeScale)), true, _local7, _local15.transitionParams);
                } else
                {
                    _local9 = new TweenListObj(_local6[_local3], (_currentTime + ((_local17 * 1000) / _timeScale)), (_currentTime + (((_local17 * 1000) + (_local16 * 1000)) / _timeScale)), false, _local7, _local15.transitionParams);
                };
                _local9.properties = _local8;
                _local9.onStart = _local15.onStart;
                _local9.onUpdate = _local15.onUpdate;
                _local9.onComplete = _local15.onComplete;
                _local9.onOverwrite = _local15.onOverwrite;
                _local9.onError = _local15.onError;
                _local9.onStartParams = _local15.onStartParams;
                _local9.onUpdateParams = _local15.onUpdateParams;
                _local9.onCompleteParams = _local15.onCompleteParams;
                _local9.onOverwriteParams = _local15.onOverwriteParams;
                _local9.onStartScope = _local15.onStartScope;
                _local9.onUpdateScope = _local15.onUpdateScope;
                _local9.onCompleteScope = _local15.onCompleteScope;
                _local9.onOverwriteScope = _local15.onOverwriteScope;
                _local9.onErrorScope = _local15.onErrorScope;
                _local9.rounded = _local15.rounded;
                _local9.skipUpdates = _local15.skipUpdates;
                if ((((_local15.overwrite == undefined)) ? autoOverwrite : _local15.overwrite))
                {
                    removeTweensByTime(_local9.scope, _local9.properties, _local9.timeStart, _local9.timeComplete);
                };
                _tweenList.push(_local9);
                if ((((_local16 == 0)) && ((_local17 == 0))))
                {
                    _local10 = (_tweenList.length - 1);
                    updateTweenByIndex(_local10);
                    removeTweenByIndex(_local10);
                };
                _local3++;
            };
            return (true);
        }
        public static function addCaller(_arg1:Object=null, _arg2:Object=null):Boolean{
            var _local3:Number;
            var _local4:Array;
            var _local5:Function;
            var _local6:TweenListObj;
            var _local7:Number;
            var _local8:String;
            if (!Boolean(_arg1))
            {
                return (false);
            };
            if ((_arg1 is Array))
            {
                _local4 = _arg1.concat();
            } else
            {
                _local4 = [_arg1];
            };
            var _local9:Object = _arg2;
            if (!_inited)
            {
                init();
            };
            if (((!(_engineExists)) || (!(Boolean(__tweener_controller__)))))
            {
                startEngine();
            };
            var _local10:Number = ((isNaN(_local9.time)) ? 0 : _local9.time);
            var _local11:Number = ((isNaN(_local9.delay)) ? 0 : _local9.delay);
            if (typeof(_local9.transition) == "string")
            {
                _local8 = _local9.transition.toLowerCase();
                _local5 = _transitionList[_local8];
            } else
            {
                _local5 = _local9.transition;
            };
            if (!Boolean(_local5))
            {
                _local5 = _transitionList["easeoutexpo"];
            };
            _local3 = 0;
            while (_local3 < _local4.length)
            {
                if (_local9.useFrames == true)
                {
                    _local6 = new TweenListObj(_local4[_local3], (_currentTimeFrame + (_local11 / _timeScale)), (_currentTimeFrame + ((_local11 + _local10) / _timeScale)), true, _local5, _local9.transitionParams);
                } else
                {
                    _local6 = new TweenListObj(_local4[_local3], (_currentTime + ((_local11 * 1000) / _timeScale)), (_currentTime + (((_local11 * 1000) + (_local10 * 1000)) / _timeScale)), false, _local5, _local9.transitionParams);
                };
                _local6.properties = null;
                _local6.onStart = _local9.onStart;
                _local6.onUpdate = _local9.onUpdate;
                _local6.onComplete = _local9.onComplete;
                _local6.onOverwrite = _local9.onOverwrite;
                _local6.onStartParams = _local9.onStartParams;
                _local6.onUpdateParams = _local9.onUpdateParams;
                _local6.onCompleteParams = _local9.onCompleteParams;
                _local6.onOverwriteParams = _local9.onOverwriteParams;
                _local6.onStartScope = _local9.onStartScope;
                _local6.onUpdateScope = _local9.onUpdateScope;
                _local6.onCompleteScope = _local9.onCompleteScope;
                _local6.onOverwriteScope = _local9.onOverwriteScope;
                _local6.onErrorScope = _local9.onErrorScope;
                _local6.isCaller = true;
                _local6.count = _local9.count;
                _local6.waitFrames = _local9.waitFrames;
                _tweenList.push(_local6);
                if ((((_local10 == 0)) && ((_local11 == 0))))
                {
                    _local7 = (_tweenList.length - 1);
                    updateTweenByIndex(_local7);
                    removeTweenByIndex(_local7);
                };
                _local3++;
            };
            return (true);
        }
        public static function removeTweensByTime(p_scope:Object, p_properties:Object, p_timeStart:Number, p_timeComplete:Number):Boolean{
            var removedLocally:Boolean;
            var i:uint;
            var pName:String;
            var eventScope:Object;
            var removed:Boolean;
            var tl:uint = _tweenList.length;
            i = 0;
            while (i < tl)
            {
                if (((Boolean(_tweenList[i])) && ((p_scope == _tweenList[i].scope))))
                {
                    if ((((p_timeComplete > _tweenList[i].timeStart)) && ((p_timeStart < _tweenList[i].timeComplete))))
                    {
                        removedLocally = false;
                        for (pName in _tweenList[i].properties)
                        {
                            if (Boolean(p_properties[pName]))
                            {
                                if (Boolean(_tweenList[i].onOverwrite))
                                {
                                    eventScope = ((Boolean(_tweenList[i].onOverwriteScope)) ? _tweenList[i].onOverwriteScope : _tweenList[i].scope);
                                    try
                                    {
                                        _tweenList[i].onOverwrite.apply(eventScope, _tweenList[i].onOverwriteParams);
                                    } catch(e:Error)
                                    {
                                        handleError(_tweenList[i], e, "onOverwrite");
                                    };
                                };
                                _tweenList[i].properties[pName] = undefined;
                                delete _tweenList[i].properties[pName];
                                removedLocally = true;
                                removed = true;
                            };
                        };
                        if (removedLocally)
                        {
                            if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0)
                            {
                                removeTweenByIndex(i);
                            };
                        };
                    };
                };
                i++;
            };
            return (removed);
        }
        public static function removeTweens(_arg1:Object, ... _args):Boolean{
            var _local3:uint;
            var _local4:SpecialPropertySplitter;
            var _local5:Array;
            var _local6:uint;
            var _local7:Array = new Array();
            _local3 = 0;
            while (_local3 < _args.length)
            {
                if ((((typeof(_args[_local3]) == "string")) && ((_local7.indexOf(_args[_local3]) == -1))))
                {
                    if (_specialPropertySplitterList[_args[_local3]])
                    {
                        _local4 = _specialPropertySplitterList[_args[_local3]];
                        _local5 = _local4.splitValues(_arg1, null);
                        _local6 = 0;
                        while (_local6 < _local5.length)
                        {
                            _local7.push(_local5[_local6].name);
                            _local6++;
                        };
                    } else
                    {
                        _local7.push(_args[_local3]);
                    };
                };
                _local3++;
            };
            return (affectTweens(removeTweenByIndex, _arg1, _local7));
        }
        public static function removeAllTweens():Boolean{
            var _local1:uint;
            var _local2:Boolean;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local1 = 0;
            while (_local1 < _tweenList.length)
            {
                removeTweenByIndex(_local1);
                _local2 = true;
                _local1++;
            };
            return (_local2);
        }
        public static function pauseTweens(_arg1:Object, ... _args):Boolean{
            var _local3:uint;
            var _local4:Array = new Array();
            _local3 = 0;
            while (_local3 < _args.length)
            {
                if ((((typeof(_args[_local3]) == "string")) && ((_local4.indexOf(_args[_local3]) == -1))))
                {
                    _local4.push(_args[_local3]);
                };
                _local3++;
            };
            return (affectTweens(pauseTweenByIndex, _arg1, _local4));
        }
        public static function pauseAllTweens():Boolean{
            var _local1:uint;
            var _local2:Boolean;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local1 = 0;
            while (_local1 < _tweenList.length)
            {
                pauseTweenByIndex(_local1);
                _local2 = true;
                _local1++;
            };
            return (_local2);
        }
        public static function resumeTweens(_arg1:Object, ... _args):Boolean{
            var _local3:uint;
            var _local4:Array = new Array();
            _local3 = 0;
            while (_local3 < _args.length)
            {
                if ((((typeof(_args[_local3]) == "string")) && ((_local4.indexOf(_args[_local3]) == -1))))
                {
                    _local4.push(_args[_local3]);
                };
                _local3++;
            };
            return (affectTweens(resumeTweenByIndex, _arg1, _local4));
        }
        public static function resumeAllTweens():Boolean{
            var _local1:uint;
            var _local2:Boolean;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local1 = 0;
            while (_local1 < _tweenList.length)
            {
                resumeTweenByIndex(_local1);
                _local2 = true;
                _local1++;
            };
            return (_local2);
        }
        private static function affectTweens(_arg1:Function, _arg2:Object, _arg3:Array):Boolean{
            var _local4:uint;
            var _local5:Array;
            var _local6:uint;
            var _local7:uint;
            var _local8:uint;
            var _local9:Boolean;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local4 = 0;
            while (_local4 < _tweenList.length)
            {
                if (((_tweenList[_local4]) && ((_tweenList[_local4].scope == _arg2))))
                {
                    if (_arg3.length == 0)
                    {
                        (_arg1(_local4));
                        _local9 = true;
                    } else
                    {
                        _local5 = new Array();
                        _local6 = 0;
                        while (_local6 < _arg3.length)
                        {
                            if (Boolean(_tweenList[_local4].properties[_arg3[_local6]]))
                            {
                                _local5.push(_arg3[_local6]);
                            };
                            _local6++;
                        };
                        if (_local5.length > 0)
                        {
                            _local7 = AuxFunctions.getObjectLength(_tweenList[_local4].properties);
                            if (_local7 == _local5.length)
                            {
                                (_arg1(_local4));
                                _local9 = true;
                            } else
                            {
                                _local8 = splitTweens(_local4, _local5);
                                (_arg1(_local8));
                                _local9 = true;
                            };
                        };
                    };
                };
                _local4++;
            };
            return (_local9);
        }
        public static function splitTweens(_arg1:Number, _arg2:Array):uint{
            var _local3:uint;
            var _local4:String;
            var _local5:Boolean;
            var _local6:TweenListObj = _tweenList[_arg1];
            var _local7:TweenListObj = _local6.clone(false);
            _local3 = 0;
            while (_local3 < _arg2.length)
            {
                _local4 = _arg2[_local3];
                if (Boolean(_local6.properties[_local4]))
                {
                    _local6.properties[_local4] = undefined;
                    delete _local6.properties[_local4];
                };
                _local3++;
            };
            for (_local4 in _local7.properties)
            {
                _local5 = false;
                _local3 = 0;
                while (_local3 < _arg2.length)
                {
                    if (_arg2[_local3] == _local4)
                    {
                        _local5 = true;
                        break;
                    };
                    _local3++;
                };
                if (!_local5)
                {
                    _local7.properties[_local4] = undefined;
                    delete _local7.properties[_local4];
                };
            };
            _tweenList.push(_local7);
            return ((_tweenList.length - 1));
        }
        private static function updateTweens():Boolean{
            var _local1:int;
            if (_tweenList.length == 0)
            {
                return (false);
            };
            _local1 = 0;
            while (_local1 < _tweenList.length)
            {
                if ((((_tweenList[_local1] == undefined)) || (!(_tweenList[_local1].isPaused))))
                {
                    if (!updateTweenByIndex(_local1))
                    {
                        removeTweenByIndex(_local1);
                    };
                    if (_tweenList[_local1] == null)
                    {
                        removeTweenByIndex(_local1, true);
                        _local1--;
                    };
                };
                _local1++;
            };
            return (true);
        }
        public static function removeTweenByIndex(_arg1:Number, _arg2:Boolean=false):Boolean{
            _tweenList[_arg1] = null;
            if (_arg2)
            {
                _tweenList.splice(_arg1, 1);
            };
            return (true);
        }
        public static function pauseTweenByIndex(_arg1:Number):Boolean{
            var _local2:TweenListObj = _tweenList[_arg1];
            if ((((_local2 == null)) || (_local2.isPaused)))
            {
                return (false);
            };
            _local2.timePaused = getCurrentTweeningTime(_local2);
            _local2.isPaused = true;
            return (true);
        }
        public static function resumeTweenByIndex(_arg1:Number):Boolean{
            var _local2:TweenListObj = _tweenList[_arg1];
            if ((((_local2 == null)) || (!(_local2.isPaused))))
            {
                return (false);
            };
            var _local3:Number = getCurrentTweeningTime(_local2);
            _local2.timeStart = (_local2.timeStart + (_local3 - _local2.timePaused));
            _local2.timeComplete = (_local2.timeComplete + (_local3 - _local2.timePaused));
            _local2.timePaused = undefined;
            _local2.isPaused = false;
            return (true);
        }
        private static function updateTweenByIndex(i:Number):Boolean{
            var tTweening:TweenListObj;
            var mustUpdate:Boolean;
            var nv:Number;
            var t:Number;
            var b:Number;
            var c:Number;
            var d:Number;
            var pName:String;
            var eventScope:Object;
            var tScope:Object;
            var tProperty:Object;
            var pv:Number;
            var isOver:Boolean;
            tTweening = _tweenList[i];
            if ((((tTweening == null)) || (!(Boolean(tTweening.scope)))))
            {
                return (false);
            };
            var cTime:Number = getCurrentTweeningTime(tTweening);
            if (cTime >= tTweening.timeStart)
            {
                tScope = tTweening.scope;
                if (tTweening.isCaller)
                {
                    do 
                    {
                        t = (((tTweening.timeComplete - tTweening.timeStart) / tTweening.count) * (tTweening.timesCalled + 1));
                        b = tTweening.timeStart;
                        c = (tTweening.timeComplete - tTweening.timeStart);
                        d = (tTweening.timeComplete - tTweening.timeStart);
                        nv = tTweening.transition(t, b, c, d);
                        if (cTime >= nv)
                        {
                            if (Boolean(tTweening.onUpdate))
                            {
                                eventScope = ((Boolean(tTweening.onUpdateScope)) ? tTweening.onUpdateScope : tScope);
                                try
                                {
                                    tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                                } catch(e1:Error)
                                {
                                    handleError(tTweening, e1, "onUpdate");
                                };
                            };
                            tTweening.timesCalled++;
                            if (tTweening.timesCalled >= tTweening.count)
                            {
                                isOver = true;
                                break;
                            };
                            if (tTweening.waitFrames) break;
                        };
                    } while (cTime >= nv);
                } else
                {
                    mustUpdate = (((((tTweening.skipUpdates < 1)) || (!(tTweening.skipUpdates)))) || ((tTweening.updatesSkipped >= tTweening.skipUpdates)));
                    if (cTime >= tTweening.timeComplete)
                    {
                        isOver = true;
                        mustUpdate = true;
                    };
                    if (!tTweening.hasStarted)
                    {
                        if (Boolean(tTweening.onStart))
                        {
                            eventScope = ((Boolean(tTweening.onStartScope)) ? tTweening.onStartScope : tScope);
                            try
                            {
                                tTweening.onStart.apply(eventScope, tTweening.onStartParams);
                            } catch(e2:Error)
                            {
                                handleError(tTweening, e2, "onStart");
                            };
                        };
                        for (pName in tTweening.properties)
                        {
                            if (tTweening.properties[pName].isSpecialProperty)
                            {
                                if (Boolean(_specialPropertyList[pName].preProcess))
                                {
                                    tTweening.properties[pName].valueComplete = _specialPropertyList[pName].preProcess(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].originalValueComplete, tTweening.properties[pName].extra);
                                };
                                pv = _specialPropertyList[pName].getValue(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                            } else
                            {
                                pv = tScope[pName];
                            };
                            tTweening.properties[pName].valueStart = ((isNaN(pv)) ? tTweening.properties[pName].valueComplete : pv);
                        };
                        mustUpdate = true;
                        tTweening.hasStarted = true;
                    };
                    if (mustUpdate)
                    {
                        for (pName in tTweening.properties)
                        {
                            tProperty = tTweening.properties[pName];
                            if (isOver)
                            {
                                nv = tProperty.valueComplete;
                            } else
                            {
                                if (tProperty.hasModifier)
                                {
                                    t = (cTime - tTweening.timeStart);
                                    d = (tTweening.timeComplete - tTweening.timeStart);
                                    nv = tTweening.transition(t, 0, 1, d, tTweening.transitionParams);
                                    nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
                                } else
                                {
                                    t = (cTime - tTweening.timeStart);
                                    b = tProperty.valueStart;
                                    c = (tProperty.valueComplete - tProperty.valueStart);
                                    d = (tTweening.timeComplete - tTweening.timeStart);
                                    nv = tTweening.transition(t, b, c, d, tTweening.transitionParams);
                                };
                            };
                            if (tTweening.rounded)
                            {
                                nv = Math.round(nv);
                            };
                            if (tProperty.isSpecialProperty)
                            {
                                _specialPropertyList[pName].setValue(tScope, nv, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                            } else
                            {
                                tScope[pName] = nv;
                            };
                        };
                        tTweening.updatesSkipped = 0;
                        if (Boolean(tTweening.onUpdate))
                        {
                            eventScope = ((Boolean(tTweening.onUpdateScope)) ? tTweening.onUpdateScope : tScope);
                            try
                            {
                                tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                            } catch(e3:Error)
                            {
                                handleError(tTweening, e3, "onUpdate");
                            };
                        };
                    } else
                    {
                        tTweening.updatesSkipped++;
                    };
                };
                if (((isOver) && (Boolean(tTweening.onComplete))))
                {
                    eventScope = ((Boolean(tTweening.onCompleteScope)) ? tTweening.onCompleteScope : tScope);
                    try
                    {
                        tTweening.onComplete.apply(eventScope, tTweening.onCompleteParams);
                    } catch(e4:Error)
                    {
                        handleError(tTweening, e4, "onComplete");
                    };
                };
                return (!(isOver));
            };
            return (true);
        }
        public static function init(... _args):void{
            _inited = true;
            _transitionList = new Object();
            Equations.init();
            _specialPropertyList = new Object();
            _specialPropertyModifierList = new Object();
            _specialPropertySplitterList = new Object();
        }
        public static function registerTransition(_arg1:String, _arg2:Function):void{
            if (!_inited)
            {
                init();
            };
            _transitionList[_arg1] = _arg2;
        }
        public static function registerSpecialProperty(_arg1:String, _arg2:Function, _arg3:Function, _arg4:Array=null, _arg5:Function=null):void{
            if (!_inited)
            {
                init();
            };
            var _local6:SpecialProperty = new SpecialProperty(_arg2, _arg3, _arg4, _arg5);
            _specialPropertyList[_arg1] = _local6;
        }
        public static function registerSpecialPropertyModifier(_arg1:String, _arg2:Function, _arg3:Function):void{
            if (!_inited)
            {
                init();
            };
            var _local4:SpecialPropertyModifier = new SpecialPropertyModifier(_arg2, _arg3);
            _specialPropertyModifierList[_arg1] = _local4;
        }
        public static function registerSpecialPropertySplitter(_arg1:String, _arg2:Function, _arg3:Array=null):void{
            if (!_inited)
            {
                init();
            };
            var _local4:SpecialPropertySplitter = new SpecialPropertySplitter(_arg2, _arg3);
            _specialPropertySplitterList[_arg1] = _local4;
        }
        private static function startEngine():void{
            _engineExists = true;
            _tweenList = new Array();
            __tweener_controller__ = new MovieClip();
            __tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            _currentTimeFrame = 0;
            updateTime();
        }
        private static function stopEngine():void{
            _engineExists = false;
            _tweenList = null;
            _currentTime = 0;
            _currentTimeFrame = 0;
            __tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            __tweener_controller__ = null;
        }
        public static function updateTime():void{
            _currentTime = getTimer();
        }
        public static function updateFrame():void{
            _currentTimeFrame++;
        }
        public static function onEnterFrame(_arg1:Event):void{
            var _local2:Boolean;
            updateTime();
            updateFrame();
            _local2 = updateTweens();
            if (!_local2)
            {
                stopEngine();
            };
        }
        public static function setTimeScale(_arg1:Number):void{
            var _local2:Number;
            var _local3:Number;
            if (isNaN(_arg1))
            {
                _arg1 = 1;
            };
            if (_arg1 < 1E-5)
            {
                _arg1 = 1E-5;
            };
            if (_arg1 != _timeScale)
            {
                if (_tweenList != null)
                {
                    _local2 = 0;
                    while (_local2 < _tweenList.length)
                    {
                        _local3 = getCurrentTweeningTime(_tweenList[_local2]);
                        _tweenList[_local2].timeStart = (_local3 - (((_local3 - _tweenList[_local2].timeStart) * _timeScale) / _arg1));
                        _tweenList[_local2].timeComplete = (_local3 - (((_local3 - _tweenList[_local2].timeComplete) * _timeScale) / _arg1));
                        if (_tweenList[_local2].timePaused != undefined)
                        {
                            _tweenList[_local2].timePaused = (_local3 - (((_local3 - _tweenList[_local2].timePaused) * _timeScale) / _arg1));
                        };
                        _local2++;
                    };
                };
                _timeScale = _arg1;
            };
        }
        public static function isTweening(_arg1:Object):Boolean{
            var _local2:uint;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local2 = 0;
            while (_local2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local2])) && ((_tweenList[_local2].scope == _arg1))))
                {
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public static function getTweens(_arg1:Object):Array{
            var _local2:uint;
            var _local3:String;
            if (!Boolean(_tweenList))
            {
                return ([]);
            };
            var _local4:Array = new Array();
            _local2 = 0;
            while (_local2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local2])) && ((_tweenList[_local2].scope == _arg1))))
                {
                    for (_local3 in _tweenList[_local2].properties)
                    {
                        _local4.push(_local3);
                    };
                };
                _local2++;
            };
            return (_local4);
        }
        public static function getTweenCount(_arg1:Object):Number{
            var _local2:uint;
            if (!Boolean(_tweenList))
            {
                return (0);
            };
            var _local3:Number = 0;
            _local2 = 0;
            while (_local2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local2])) && ((_tweenList[_local2].scope == _arg1))))
                {
                    _local3 = (_local3 + AuxFunctions.getObjectLength(_tweenList[_local2].properties));
                };
                _local2++;
            };
            return (_local3);
        }
        private static function handleError(pTweening:TweenListObj, pError:Error, pCallBackName:String):void{
            var eventScope:Object;
            if (((Boolean(pTweening.onError)) && ((pTweening.onError is Function))))
            {
                eventScope = ((Boolean(pTweening.onErrorScope)) ? pTweening.onErrorScope : pTweening.scope);
                try
                {
                    pTweening.onError.apply(eventScope, [pTweening.scope, pError]);
                } catch(metaError:Error)
                {
                    printError(((((String(pTweening.scope) + " raised an error while executing the 'onError' handler. Original error:\n ") + pError.getStackTrace()) + "\nonError error: ") + metaError.getStackTrace()));
                };
            } else
            {
                if (!Boolean(pTweening.onError))
                {
                    printError(((((String(pTweening.scope) + " raised an error while executing the '") + pCallBackName) + "'handler. \n") + pError.getStackTrace()));
                };
            };
        }
        public static function getCurrentTweeningTime(_arg1:Object):Number{
            return (((_arg1.useFrames) ? _currentTimeFrame : _currentTime));
        }
        public static function getVersion():String{
            return ("AS3 1.33.74");
        }
        public static function printError(_arg1:String):void{
            trace(("## [Tweener] Error: " + _arg1));
        }

    }
}//package caurina.transitions

