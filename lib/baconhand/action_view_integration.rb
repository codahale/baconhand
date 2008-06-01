require "baconhand"

# Rails 2.0
Baconhand.wrap(ActionView::Base, :render)
Baconhand.wrap(ActionView::Base, :render_file)
Baconhand.wrap(ActionView::Base, :render_template)

# Rails 2.1+
Baconhand.wrap(ActionView::Base, :execute)
