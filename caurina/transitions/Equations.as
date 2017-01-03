// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//caurina.transitions.Equations

package caurina.transitions{
    public class Equations {

        public function Equations(){
            trace("Equations is a static class and should not be instantiated.");
        }
        public static function init():void{
            Tweener.registerTransition("easenone", easeNone);
            Tweener.registerTransition("linear", easeNone);
            Tweener.registerTransition("easeinquad", easeInQuad);
            Tweener.registerTransition("easeoutquad", easeOutQuad);
            Tweener.registerTransition("easeinoutquad", easeInOutQuad);
            Tweener.registerTransition("easeoutinquad", easeOutInQuad);
            Tweener.registerTransition("easeincubic", easeInCubic);
            Tweener.registerTransition("easeoutcubic", easeOutCubic);
            Tweener.registerTransition("easeinoutcubic", easeInOutCubic);
            Tweener.registerTransition("easeoutincubic", easeOutInCubic);
            Tweener.registerTransition("easeinquart", easeInQuart);
            Tweener.registerTransition("easeoutquart", easeOutQuart);
            Tweener.registerTransition("easeinoutquart", easeInOutQuart);
            Tweener.registerTransition("easeoutinquart", easeOutInQuart);
            Tweener.registerTransition("easeinquint", easeInQuint);
            Tweener.registerTransition("easeoutquint", easeOutQuint);
            Tweener.registerTransition("easeinoutquint", easeInOutQuint);
            Tweener.registerTransition("easeoutinquint", easeOutInQuint);
            Tweener.registerTransition("easeinsine", easeInSine);
            Tweener.registerTransition("easeoutsine", easeOutSine);
            Tweener.registerTransition("easeinoutsine", easeInOutSine);
            Tweener.registerTransition("easeoutinsine", easeOutInSine);
            Tweener.registerTransition("easeincirc", easeInCirc);
            Tweener.registerTransition("easeoutcirc", easeOutCirc);
            Tweener.registerTransition("easeinoutcirc", easeInOutCirc);
            Tweener.registerTransition("easeoutincirc", easeOutInCirc);
            Tweener.registerTransition("easeinexpo", easeInExpo);
            Tweener.registerTransition("easeoutexpo", easeOutExpo);
            Tweener.registerTransition("easeinoutexpo", easeInOutExpo);
            Tweener.registerTransition("easeoutinexpo", easeOutInExpo);
            Tweener.registerTransition("easeinelastic", easeInElastic);
            Tweener.registerTransition("easeoutelastic", easeOutElastic);
            Tweener.registerTransition("easeinoutelastic", easeInOutElastic);
            Tweener.registerTransition("easeoutinelastic", easeOutInElastic);
            Tweener.registerTransition("easeinback", easeInBack);
            Tweener.registerTransition("easeoutback", easeOutBack);
            Tweener.registerTransition("easeinoutback", easeInOutBack);
            Tweener.registerTransition("easeoutinback", easeOutInBack);
            Tweener.registerTransition("easeinbounce", easeInBounce);
            Tweener.registerTransition("easeoutbounce", easeOutBounce);
            Tweener.registerTransition("easeinoutbounce", easeInOutBounce);
            Tweener.registerTransition("easeoutinbounce", easeOutInBounce);
        }
        public static function easeNone(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return ((((_arg3 * _arg1) / _arg4) + _arg2));
        }
        public static function easeInQuad(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return ((((_arg3 * _arg1) * _arg1) + _arg2));
        }
        public static function easeOutQuad(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return ((((-(_arg3) * _arg1) * (_arg1 - 2)) + _arg2));
        }
        public static function easeInOutQuad(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return (((((_arg3 / 2) * _arg1) * _arg1) + _arg2));
            };
            return ((((-(_arg3) / 2) * ((--_arg1 * (_arg1 - 2)) - 1)) + _arg2));
        }
        public static function easeOutInQuad(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutQuad((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInQuad(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInCubic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return (((((_arg3 * _arg1) * _arg1) * _arg1) + _arg2));
        }
        public static function easeOutCubic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * (((_arg1 * _arg1) * _arg1) + 1)) + _arg2));
        }
        public static function easeInOutCubic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return ((((((_arg3 / 2) * _arg1) * _arg1) * _arg1) + _arg2));
            };
            _arg1 = (_arg1 - 2);
            return ((((_arg3 / 2) * (((_arg1 * _arg1) * _arg1) + 2)) + _arg2));
        }
        public static function easeOutInCubic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutCubic((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInCubic(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInQuart(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return ((((((_arg3 * _arg1) * _arg1) * _arg1) * _arg1) + _arg2));
        }
        public static function easeOutQuart(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((-(_arg3) * ((((_arg1 * _arg1) * _arg1) * _arg1) - 1)) + _arg2));
        }
        public static function easeInOutQuart(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return (((((((_arg3 / 2) * _arg1) * _arg1) * _arg1) * _arg1) + _arg2));
            };
            _arg1 = (_arg1 - 2);
            return ((((-(_arg3) / 2) * ((((_arg1 * _arg1) * _arg1) * _arg1) - 2)) + _arg2));
        }
        public static function easeOutInQuart(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutQuart((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInQuart(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInQuint(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return (((((((_arg3 * _arg1) * _arg1) * _arg1) * _arg1) * _arg1) + _arg2));
        }
        public static function easeOutQuint(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * (((((_arg1 * _arg1) * _arg1) * _arg1) * _arg1) + 1)) + _arg2));
        }
        public static function easeInOutQuint(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return ((((((((_arg3 / 2) * _arg1) * _arg1) * _arg1) * _arg1) * _arg1) + _arg2));
            };
            _arg1 = (_arg1 - 2);
            return ((((_arg3 / 2) * (((((_arg1 * _arg1) * _arg1) * _arg1) * _arg1) + 2)) + _arg2));
        }
        public static function easeOutInQuint(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutQuint((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInQuint(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInSine(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return ((((-(_arg3) * Math.cos(((_arg1 / _arg4) * (Math.PI / 2)))) + _arg3) + _arg2));
        }
        public static function easeOutSine(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return (((_arg3 * Math.sin(((_arg1 / _arg4) * (Math.PI / 2)))) + _arg2));
        }
        public static function easeInOutSine(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return ((((-(_arg3) / 2) * (Math.cos(((Math.PI * _arg1) / _arg4)) - 1)) + _arg2));
        }
        public static function easeOutInSine(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutSine((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInSine(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInExpo(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return ((((_arg1)==0) ? _arg2 : (((_arg3 * Math.pow(2, (10 * ((_arg1 / _arg4) - 1)))) + _arg2) - (_arg3 * 0.001))));
        }
        public static function easeOutExpo(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return ((((_arg1)==_arg4) ? (_arg2 + _arg3) : (((_arg3 * 1.001) * (-(Math.pow(2, ((-10 * _arg1) / _arg4))) + 1)) + _arg2)));
        }
        public static function easeInOutExpo(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 == 0)
            {
                return (_arg2);
            };
            if (_arg1 == _arg4)
            {
                return ((_arg2 + _arg3));
            };
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return (((((_arg3 / 2) * Math.pow(2, (10 * (_arg1 - 1)))) + _arg2) - (_arg3 * 0.0005)));
            };
            return (((((_arg3 / 2) * 1.0005) * (-(Math.pow(2, (-10 * --_arg1))) + 2)) + _arg2));
        }
        public static function easeOutInExpo(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutExpo((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInExpo(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInCirc(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            return (((-(_arg3) * (Math.sqrt((1 - (_arg1 * _arg1))) - 1)) + _arg2));
        }
        public static function easeOutCirc(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * Math.sqrt((1 - (_arg1 * _arg1)))) + _arg2));
        }
        public static function easeInOutCirc(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return ((((-(_arg3) / 2) * (Math.sqrt((1 - (_arg1 * _arg1))) - 1)) + _arg2));
            };
            _arg1 = (_arg1 - 2);
            return ((((_arg3 / 2) * (Math.sqrt((1 - (_arg1 * _arg1))) + 1)) + _arg2));
        }
        public static function easeOutInCirc(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutCirc((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInCirc(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInElastic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number;
            if (_arg1 == 0)
            {
                return (_arg2);
            };
            _arg1 = (_arg1 / _arg4);
            if (_arg1 == 1)
            {
                return ((_arg2 + _arg3));
            };
            var _local7:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.period)))) ? (_arg4 * 0.3) : _arg5.period);
            var _local8:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.amplitude)))) ? 0 : _arg5.amplitude);
            if (((!(Boolean(_local8))) || ((_local8 < Math.abs(_arg3)))))
            {
                _local8 = _arg3;
                _local6 = (_local7 / 4);
            } else
            {
                _local6 = ((_local7 / (2 * Math.PI)) * Math.asin((_arg3 / _local8)));
            };
            return ((-(((_local8 * Math.pow(2, (10 * --_arg1))) * Math.sin(((((_arg1 * _arg4) - _local6) * (2 * Math.PI)) / _local7)))) + _arg2));
        }
        public static function easeOutElastic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number;
            if (_arg1 == 0)
            {
                return (_arg2);
            };
            _arg1 = (_arg1 / _arg4);
            if (_arg1 == 1)
            {
                return ((_arg2 + _arg3));
            };
            var _local7:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.period)))) ? (_arg4 * 0.3) : _arg5.period);
            var _local8:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.amplitude)))) ? 0 : _arg5.amplitude);
            if (((!(Boolean(_local8))) || ((_local8 < Math.abs(_arg3)))))
            {
                _local8 = _arg3;
                _local6 = (_local7 / 4);
            } else
            {
                _local6 = ((_local7 / (2 * Math.PI)) * Math.asin((_arg3 / _local8)));
            };
            return (((((_local8 * Math.pow(2, (-10 * _arg1))) * Math.sin(((((_arg1 * _arg4) - _local6) * (2 * Math.PI)) / _local7))) + _arg3) + _arg2));
        }
        public static function easeInOutElastic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number;
            if (_arg1 == 0)
            {
                return (_arg2);
            };
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 == 2)
            {
                return ((_arg2 + _arg3));
            };
            var _local7:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.period)))) ? (_arg4 * (0.3 * 1.5)) : _arg5.period);
            var _local8:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.amplitude)))) ? 0 : _arg5.amplitude);
            if (((!(Boolean(_local8))) || ((_local8 < Math.abs(_arg3)))))
            {
                _local8 = _arg3;
                _local6 = (_local7 / 4);
            } else
            {
                _local6 = ((_local7 / (2 * Math.PI)) * Math.asin((_arg3 / _local8)));
            };
            if (_arg1 < 1)
            {
                return (((-0.5 * ((_local8 * Math.pow(2, (10 * --_arg1))) * Math.sin(((((_arg1 * _arg4) - _local6) * (2 * Math.PI)) / _local7)))) + _arg2));
            };
            return ((((((_local8 * Math.pow(2, (-10 * --_arg1))) * Math.sin(((((_arg1 * _arg4) - _local6) * (2 * Math.PI)) / _local7))) * 0.5) + _arg3) + _arg2));
        }
        public static function easeOutInElastic(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutElastic((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInElastic(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInBack(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.overshoot)))) ? 1.70158 : _arg5.overshoot);
            _arg1 = (_arg1 / _arg4);
            return (((((_arg3 * _arg1) * _arg1) * (((_local6 + 1) * _arg1) - _local6)) + _arg2));
        }
        public static function easeOutBack(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.overshoot)))) ? 1.70158 : _arg5.overshoot);
            _arg1 = ((_arg1 / _arg4) - 1);
            return (((_arg3 * (((_arg1 * _arg1) * (((_local6 + 1) * _arg1) + _local6)) + 1)) + _arg2));
        }
        public static function easeInOutBack(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            var _local6:Number = ((((!(Boolean(_arg5))) || (isNaN(_arg5.overshoot)))) ? 1.70158 : _arg5.overshoot);
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                _local6 = (_local6 * 1.525);
                return ((((_arg3 / 2) * ((_arg1 * _arg1) * (((_local6 + 1) * _arg1) - _local6))) + _arg2));
            };
            _arg1 = (_arg1 - 2);
            _local6 = (_local6 * 1.525);
            return ((((_arg3 / 2) * (((_arg1 * _arg1) * (((_local6 + 1) * _arg1) + _local6)) + 2)) + _arg2));
        }
        public static function easeOutInBack(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutBack((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInBack(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }
        public static function easeInBounce(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            return (((_arg3 - easeOutBounce((_arg4 - _arg1), 0, _arg3, _arg4)) + _arg2));
        }
        public static function easeOutBounce(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            _arg1 = (_arg1 / _arg4);
            if (_arg1 < (1 / 2.75))
            {
                return (((_arg3 * ((7.5625 * _arg1) * _arg1)) + _arg2));
            };
            if (_arg1 < (2 / 2.75))
            {
                _arg1 = (_arg1 - (1.5 / 2.75));
                return (((_arg3 * (((7.5625 * _arg1) * _arg1) + 0.75)) + _arg2));
            };
            if (_arg1 < (2.5 / 2.75))
            {
                _arg1 = (_arg1 - (2.25 / 2.75));
                return (((_arg3 * (((7.5625 * _arg1) * _arg1) + 0.9375)) + _arg2));
            };
            _arg1 = (_arg1 - (2.625 / 2.75));
            return (((_arg3 * (((7.5625 * _arg1) * _arg1) + 0.984375)) + _arg2));
        }
        public static function easeInOutBounce(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (((easeInBounce((_arg1 * 2), 0, _arg3, _arg4) * 0.5) + _arg2));
            };
            return ((((easeOutBounce(((_arg1 * 2) - _arg4), 0, _arg3, _arg4) * 0.5) + (_arg3 * 0.5)) + _arg2));
        }
        public static function easeOutInBounce(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null):Number{
            if (_arg1 < (_arg4 / 2))
            {
                return (easeOutBounce((_arg1 * 2), _arg2, (_arg3 / 2), _arg4, _arg5));
            };
            return (easeInBounce(((_arg1 * 2) - _arg4), (_arg2 + (_arg3 / 2)), (_arg3 / 2), _arg4, _arg5));
        }

    }
}//package caurina.transitions

