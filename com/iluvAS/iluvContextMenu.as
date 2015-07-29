package iluvAS 
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvContextMenu
	{
		
		public static function initContext(spr:Sprite):void
		{
			var wholeMenu:ContextMenu = new ContextMenu();
			var iluvItem:ContextMenuItem = new ContextMenuItem("iluvAS Games");
			wholeMenu.hideBuiltInItems();
			wholeMenu.customItems.push(iluvItem);
			iluvItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, iluvEvent);
			spr.contextMenu = wholeMenu;
		}
		
		private static function iluvEvent(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest(iluvGameProperties.DEVELOPER_SITE));
		}
		
	}

}