require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repo, :name, :description, :keywords, :types, :app, :documentation, :user
  attr_writer :author, :type, :documentation, :app_id

  def author
    @author || @user.try(:email)
  end

  def type
    @type || types.first.name
  end

  def app_id
    @app_id || @app.try(:id)
  end

  def documentation
    @documentation || @app.try(:documentation)
  end

  def save
    if template = create_template
      save_template_to_repo(template)
    end
  end

  private

  def create_template
    Template.create(
      name: name,
      description: description,
      keywords: keywords,
      authors: [author],
      type: type,
      app_id: app_id,
      documentation: documentation
    )
  end

  def save_template_to_repo(template)
    body = {
      repo: repo,
      file_name: name.downcase.gsub(/\s/, '_')
    }
    template.post(:save, body)
  end
end