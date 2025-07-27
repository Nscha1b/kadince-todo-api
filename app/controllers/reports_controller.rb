require "tempfile"

class ReportsController < ApplicationController
  include ActionView::Rendering

  before_action :authenticate_user!

  def todo
    @current_user = current_user
    @todos = TodoFilter.new(current_user.todos, todos_params).call

    html_content = render_to_string(template: "reports/todo")
    pdf_data = WickedPdf.new.pdf_from_string(html_content)

    send_data pdf_data,
              filename: "todos_report.pdf",
              type: "application/pdf",
              disposition: "attachment; filename=todos_report.pdf"
  end

  private
  def todos_params
    params.permit(:completed)
  end
end
