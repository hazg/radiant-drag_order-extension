class DragOrderExtension < Radiant::Extension
  version YAML::load_file(File.join(File.dirname(__FILE__), 'VERSION'))
  description "Radiant DragOrder allows you to reorder pages funly"
  url "https://github.com/dirkkelly/radiant-drag-order"
  
  # HACK: Using define_routes instead of config/routes.rb because in Radiant
  # Edge (~a43878e3dd05c3eaceffdb17182b63dce3a529fc) the routes from routes.rb
  # aren't resolved. They are loaded (and show up in rake routes) but not in
  # the right priority, i.e.
  # ActionController::Routing::Routes.recognize_path('/admin/pages/sort.js', :method=>:put)
  # doesn't return {:controller=>"admin/pages", :format=>"js", :action=>"sort"}
  # like it should
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :pages, :collection => { :sort => :put }
    end
  end
  
  def activate
    Page.send :include, DragOrder::Models::Page
    StandardTags.send :include, DragOrder::Tags::Core
    Admin::PagesController.send :include, DragOrder::Controllers::Admin::PagesController
    Admin::NodeHelper.send :include, DragOrder::Helpers::Admin::NodeHelper
    
    admin.pages.index.add :node,  "handle", :before => "title_column"
  end
  
end