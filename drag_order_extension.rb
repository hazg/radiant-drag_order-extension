# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class DragOrderExtension < Radiant::Extension
	version "0.2"
	description "This extension allows pages to be moved to any arbitrary (valid) place in the 
document tree structure by dragging the page to its new position and dropping it there. Created by 
Bright 4, February 2009. Inspired by and based on Sean Cribbs' Reorder extension."
	url "http://www.bright4.nl/"

	define_routes do |map|
		map.with_options :controller => "admin/page" do |page|
			page.page_move_to "admin/pages/:id/move_to/:rel/:pos", :action => "move_to"
		end
	end

	def activate
		admin.page.index.add :sitemap_head, "drag_order_header"
		admin.page.index.add :node, "drag_order"
		admin.page.index.add :top, "header"
		Page.send :include, DragOrder::PageExtensions
		(Admin::PageController rescue Admin::PagesController).send :helper, DragOrder::PageHelper
		(Admin::PageController rescue Admin::PagesController).send :include, DragOrder::PageControllerExtensions
		StandardTags.send :include, DragOrder::TagExtensions
	end

	def deactivate
	end
	
end