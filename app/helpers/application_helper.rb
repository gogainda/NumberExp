module ApplicationHelper
  def page_title(title)
    content_for(:page_title, title.to_s)
  end

  def page_meta_title(title)
    content_for(:page_meta_title, title.to_s)
  end

  def page_meta_description(description)
    content_for(:page_meta_description, description.to_s)
  end

  def meta_tags
    content_for(:meta_tags) do
      yield
    end
  end

  def meta_tag(name, value)
    tag(:meta, name: name, content: value)
  end
end
