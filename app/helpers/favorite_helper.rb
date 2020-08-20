module FavoriteHelper
  def render_errors(obj)
    obj.errors.full_messages.each { |mess| flash[:warning] = mess }
  end
end
