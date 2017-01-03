// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.External

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.main.MainViewController;
    import flash.net.*;
    import com.viroxoty.fashionista.boutique.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.external.*;

    public class External {

        public static const AS_SKIP_BUY:int = 2;
        public static const AS_SHARE_WALL:int = 3;
        public static const AS_REQUEST_FREE:int = 4;
        public static const AS_ENTER_LOOK:int = 5;
		public static const GIFT_ID:int=0;
		public static const GIFT_TYPE:String="";
		
        static var item_gift_callback:Function;
        static var item_gift_fail_callback:Function;
        static var item_gift_type:String;
        static var item_id:int;

        public static function set_callbacks():void{
            ExternalInterface.addCallback("purchaseOverlayClosed", External.purchaseOverlayClosed);
            ExternalInterface.addCallback("goPetsBoutique", External.goPetsBoutique);
            ExternalInterface.addCallback("pauseGame", External.pauseGame);
            ExternalInterface.addCallback("resumeGame", External.resumeGame);
			ExternalInterface.addCallback("hideModalPopup", External.hideModalPopup);
			ExternalInterface.addCallback("SendGiftToFriend", External.SendGiftToFriend);
			
        }
        public static function init():void{
            Tracer.out(((("ExternalInterface.available = " + ExternalInterface.available) + ", objectID = ") + ExternalInterface.objectID));
            Tracer.out("External > init: calling fashionista.external.initPurchaseOverlay(null, 'purchaseOverlayClosed')");
            ExternalInterface.call("fashionista.external.initPurchaseOverlay", null, "purchaseOverlayClosed");
        }
        public static function initLikeButton(_arg1:String, _arg2:String=null){
            var _local3:int;
            var _local4:int;
            switch (_arg1)
            {
                case "judge":
                    _arg2 = Constants.JOEL_URL;
                    _local3 = 168;
                    _local4 = 530;
                    break;
                case "item":
                case "decor":
                    _local3 = 230;
                    _local4 = 260;
                    break;
                case "boutiqueLevel":
                    _local3 = 660;
                    _local4 = 105;
                    break;
                default:
                    Tracer.out((("initLikeButton: unrecognized type " + _arg1) + "; bailing"));
                    return;
            };
            _local4 = (_local4 - Constants.SCREEN_HEIGHT);
            _arg2 = Util.url_with_http(_arg2);
            Tracer.out((((((((("ExternalInterface.call - fashionista.external.initLikeButton('" + _arg1) + "', '") + _arg2) + "', ") + _local3) + ", ") + _local4) + ")"));
            ExternalInterface.call("fashionista.external.initLikeButton", _arg1, _arg2, _local3, _local4);
        }
		
		public static function showLikeButton(){
            Tracer.out("ExternalInterface.call('fashionista.external.showLikeButton', true)");
            ExternalInterface.call("fashionista.external.showLikeButton", true);
        }
		
				
		public static function CallFacebookUI(strMethodName:String,_arg1:Object):void{
			Tracer.out("ExternalInterface.call('fashionista.external.CallFacebookUI')"+_arg1);
			ExternalInterface.call("fashionista.external.CallFacebookUI", strMethodName,_arg1);
		}
		
		public static function CallFacebookAPI(strMethodName:String, _arg1:Object, _arg2:String="feed", _arg3:Function=null, _arg4:String="me"):void{
			Tracer.out("ExternalInterface.call('fashionista.external.CallFacebookAPI')"+_arg1);
			ExternalInterface.call("fashionista.external.CallFacebookAPI", strMethodName,_arg1,_arg2,_arg3,_arg4);
		}
      
        public static function hideLikeButton(){
            Tracer.out("ExternalInterface.call('fashionista.external.showLikeButton', false)");
            ExternalInterface.call("fashionista.external.showLikeButton", false);
        }
        public static function showXFBMLLikeButton(){
            Tracer.out("ExternalInterface.call('fashionista.external.showXFBMLLikeButton', true)");
            ExternalInterface.call("fashionista.external.showXFBMLLikeButton", true);
        }
        public static function hideXFBMLLikeButton(){
            Tracer.out("ExternalInterface.call('fashionista.external.showXFBMLLikeButton', false)");
            ExternalInterface.call("fashionista.external.showXFBMLLikeButton", false);
        }
        public static function pauseGame():void{
            Tracer.out("External > pauseGame");
            MainViewController.getInstance().pause();
        }
        public static function resumeGame():void{
            Tracer.out("External > resumeGame");
            MainViewController.getInstance().resume();
        }
		
		 public static function hideModalPopup():void{
            Tracer.out("External > hidemodal_html_popup val ");
            MainViewController.getInstance().hide_modal_html_popup();
        }
		
		public static function SendGiftToFriend(objResponse:Object):void{
			//var arrUsers:Array= objResponse.to;
			Tracer.out("Response  req id "+objResponse.request);
			DataManager.getInstance().process_gift_requests(objResponse.request,objResponse.to,GIFT_ID,GIFT_TYPE);
			
			MainViewController.getInstance().hide_modal_html_popup();
			UserData.getInstance().daily_free_give = true;
            DataManager.getInstance().track_daily_free_gift();            
		}
		
        public static function open_top_page():void{
            open_top_php(10);
        }
        public static function open_last_weeks_winners():void{
            open_top_php(5);
        }
        public static function open_user_looks():void{
            open_top_php(3);
        }
        public static function open_top_teams():void{
            open_top_php(8);
        }
        public static function open_top_daily():void{
            open_top_php(1);
        }
        public static function open_top10_friends():void{
            open_top_php(2);
        }
        static function open_top_php(_arg1:int){
            navigateToURL(new URLRequest((Constants.TOP_PAGE_URL + _arg1)), "_newtab");
        }
        public static function addcash_window():void{
            Tracer.out("External > addcash_window : calling fashionista.external.showPurchaseOverlay");
            ExternalInterface.call("fashionista.external.showPurchaseOverlay");
            MainViewController.getInstance().pause();
        }
        public static function purchaseOverlayClosed(_arg1:Boolean=false):void{
            Tracer.out(("purchaseOverlayClosed called; purchaseSuccess = " + _arg1));
            MainViewController.getInstance().resume();
            if (_arg1)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.BOUGHT_CASH);
                DataManager.getInstance().check_user_balances();
            };
        }
        public static function openFreeItemOffer():void{
            showSocialFlex();
            UserData.getInstance().reward_free_item();
            DataManager.getInstance().reward_free_offer_item(DataManager.getInstance().free_item.id);
            MainViewController.getInstance().hide_free_item_btn();
        }
		
        public static function goPetsBoutique():void{
            var mvc:MainViewController;
            Tracer.out("External > goPetsBoutique");
            if (Main.getInstance().current_section == null)
            {
                Tracer.out("not yet in intro; bailing");
                return;
            };
            if (Main.getInstance().current_section == "intro")
            {
                mvc = MainViewController.getInstance();
                mvc.exit_intro();
                mvc.addEventListener(MainViewController.FIRST_SCREEN_READY, function (){
                    BoutiqueManager.getInstance().setup_boutique_by_name("pets");
                });
            } else
            {
                BoutiqueManager.getInstance().setup_boutique_by_name("pets");
            };
        }
        public static function showAppssavvy(_arg1:int):void{
            if (UserData.getInstance().first_time_visit())
            {
                return;
            };
            Tracer.out((("calling fashionista.external.openAppssavvy(" + _arg1) + ")"));
            ExternalInterface.call("fashionista.external.openAppssavvy", _arg1);
        }
        public static function showSocialFlex():void{
            Tracer.out("calling fashionista.external.showSocialFlex()");
            ExternalInterface.call("fashionista.external.showSocialFlex");
        }

    }
}//package com.viroxoty.fashionista

