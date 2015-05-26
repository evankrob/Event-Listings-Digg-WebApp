module TaggableWithProxy
  def self.included(base)
    base.class_eval do
      acts_as_taggable

      def tag_list_proxy
        self.tag_list
      end

      def tag_list_proxy=(tags)
        self.tag_list = tags
      end
    end
  end
end
