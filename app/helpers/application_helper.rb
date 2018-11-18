module ApplicationHelper
  # Generic function for adding form fields dynamically to an existing form. This method will take in the form builder
  # for the top level object and the association for which the nested `fields_for` function is building out nested fields.
  # It creates a new instance of the association class and then calls its form_builder and nests it under the top level
  # object with a new id.
  #
  # Example: For the Order form with nested LineItems associated, this method creates a new LineItem, gets its id for
  # appending it as a child object of the Order class, and renders the partial `_line_item_fields` with the new child index
  # passed in.
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")})
  end
end
