
module Rich
  module Cms
    module Controller
    
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          helper_method :current_rich_cms_admin      , :current_rich_cms_admin_name, 
                        :rich_cms_authenticated_class, :rich_cms_authentication_inputs
        end
      end

      module InstanceMethods
      
      protected
  
        def require_current_rich_cms_admin
          unless current_rich_cms_admin
            redirect_to root_url
            return false
          end
        end

        def current_rich_cms_admin
          case rich_cms_auth.logic
          when :authlogic
            return @current_rich_cms_admin if defined?(@current_rich_cms_admin)
            @current_rich_cms_admin_session ||= rich_cms_authenticated_class.find
            @current_rich_cms_admin = @current_rich_cms_admin_session.try rich_cms_auth.specs[:class].name.demodulize.underscore
          end
        end
    
        def current_rich_cms_admin_name
          current_rich_cms_admin[rich_cms_auth.specs[:identifier]] if current_rich_cms_admin
        end
        
        def rich_cms_auth
          ::Rich::Cms::Engine.authentication
        end
        
        def rich_cms_authenticated_class
          case rich_cms_auth.logic
          when :authlogic
            "#{rich_cms_auth.specs[:class].name}Session".constantize
          end
        end
        
        def rich_cms_authentication_inputs
          case rich_cms_auth.logic
          when :authlogic
            rich_cms_auth.specs[:inputs] || [:email, :password]
          end
        end
      
      end
    
    end
  end
end
