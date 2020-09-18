class SearchController < ApplicationController
  NUMBER_RECORD_IN_PAGE = 10
  before_action :load_data_dropdown, only: :multi_search

  def multi_search
    solr = connect_solr
    @keyword = params[:keyword]
    @industry = Industry.find_by(id: params[:industry]) if params[:industry].present?
    @city = City.find_by(id: params[:city]) if params[:city].present?
    # Value data is Array, index[0]: name_job or company name, index[1]: id industry, index[2]: id location
    data = sub_space_params!(params[:keyword], params[:industry], params[:city])
    query = if params[:keyword].blank? && params[:industry].blank? && params[:city].blank?
              '*:*'
            else
              "solr((name: #{data[0]}) OR (company_name: #{data[0]})) AND (industry_id: #{data[1]}) AND (location_id: #{data[2]})"
            end
    response = solr.paginate(params[:page], NUMBER_RECORD_IN_PAGE, 'select', params: { q: query })    
    @results = Kaminari.paginate_array(response['response']['docs'], total_count: response['response']['numFound']).page(params[:page]).per(NUMBER_RECORD_IN_PAGE)
    return render 'error/page_not_found' if params[:page].to_i > @results.total_pages
    render :result
  end

  def sub_space_params!(keyword, industry_id, location_id)
    arr_params = []
    keyword = keyword.present? ? Regexp.escape(keyword) : ''
    industry_id = industry_id.present? ? Regexp.escape(industry_id) : ''
    location_id = location_id.present? ? Regexp.escape(location_id) : ''
    arr_params << keyword << industry_id << location_id
    arr_params.each { |val| val.sub!('', '*') if val.blank? }
  end

  def load_data_dropdown
    @industries = Industry.order(name: :asc).all
    @cities = City.select(:id, :name)
  end

  private

  def connect_solr
    SolrSetting::SolrServer.connection
  end
end
