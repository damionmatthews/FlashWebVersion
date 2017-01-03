// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.messages.MessageDataObject

package com.viroxoty.fashionista.messages{
    import com.viroxoty.fashionista.data.PurchasableObject;
    import com.viroxoty.fashionista.data.Team;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import com.viroxoty.fashionista.util.*;

    public class MessageDataObject {

        public var id:int;
        public var type:String;
        public var is_a_list:int;
        public var sender:String;
        public var sender_name:String;
        public var sender_pic:String;
        public var receiver:String;
        public var text:String;
        public var viewed:int;
        public var item:PurchasableObject;
        public var itemPng:String;
        public var timestamp:int;
        public var team:Team;
        public var view:MovieClip;
        public var client_generated:Boolean;

        public function parseMessageObj(_arg1:Object):void{
            this.id = int(_arg1.id);
            this.type = _arg1.type;
            this.receiver = _arg1.receiver_id;
            this.sender = _arg1.sender_id;
            this.sender_name = _arg1.senderName;
            this.sender_pic = _arg1.senderPic;
            this.text = _arg1.text;
            this.timestamp = _arg1.timestamp;
            if (_arg1.Item_ID)
            {
                if (this.type == MessageViewController.TYPE_GIFT)
                {
                    this.type = MessageViewController.TYPE_PERFUME_GIFT;
                };
                if (MessageViewController.decor_types.indexOf(this.type) > -1)
                {
                    this.item = Decor.parseMessageItem(_arg1);
                    this.itemPng = (Constants.SERVER_DECOR_IMAGES + _arg1.itemPng);
                } else
                {
                    this.item = new Item();
                    this.item.parseMessageItem(_arg1);
                    this.itemPng = (Constants.SERVER_ITEM_IMAGES + _arg1.itemPng);
                };
            };
            this.viewed = int(_arg1.viewed);
        }
        public function setupDailyDealMessage(_arg1:Item):void{
            this.type = MessageViewController.TYPE_DAILY_DEAL;
            this.sender_name = "Joel Goodrich";
            this.sender_pic = (Constants.SERVER_IMAGES + "dealoftheday.png");
            this.text = "This NEW item is on sale today only!";
            this.item = _arg1;
            this.itemPng = this.item.png;
            this.client_generated = true;
        }
        public function setupDailyFreeItemMessage(_arg1:Item):void{
            this.type = MessageViewController.TYPE_DAILY_FREE_ITEM;
            this.sender_name = "Joel Goodrich";
            this.sender_pic = (Constants.SERVER_IMAGES + "joel_with_models.png");
            this.text = "Click here to get this Free Item!";
            this.item = _arg1;
            this.itemPng = this.item.png;
            this.client_generated = true;
        }
        public function setupJoinTeamMessage():void{
            this.type = MessageViewController.TYPE_JOIN_TEAM;
            this.text = "Join a Fabulous FashionTeam and win 100 free points!";
            this.sender_pic = (Constants.SERVER_IMAGES + "join_team.png");
            this.client_generated = true;
        }
        public function setupBoutiqueEarningsMessage(_arg1:int):void{
            this.type = MessageViewController.TYPE_BOUTIQUE_EARNINGS;
            this.text = (("You've earned " + _arg1) + " FashionCash from your boutique!");
            this.sender_pic = UserData.getInstance().my_boutique_url;
            this.client_generated = true;
        }
        public function setupLaunchBoutiqueMessage():void{
            this.type = MessageViewController.TYPE_LAUNCH_BOUTIQUE;
            this.text = "Earn FashionCash by launching your boutique!";
            this.sender_pic = UserData.getInstance().my_boutique_url;
            this.client_generated = true;
        }
        public function setupFashionEmpireEarningsMessage(_arg1:int):void{
            this.type = MessageViewController.TYPE_FASHION_EARNINGS;
            this.text = (("You've earned " + _arg1) + " FashionCash from your Fashion Empire!");
            this.sender_name = "Joel Goodrich";
            this.sender_pic = (Constants.SERVER_IMAGES + "joel_with_models.png");
            this.client_generated = true;
        }

    }
}//package com.viroxoty.fashionista.messages

