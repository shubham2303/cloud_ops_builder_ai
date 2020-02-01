module Operations
  class GetPricing

    def initialize(params)
      @params = params
      @pl = PricingList.last
      @begin_range = params[:beginRange].to_s
      @end_range = params[:endRange].to_s
      @effective_date = params[:date].to_s || params[:effectiveDate].to_s
      @match = {}
    end

    def run
      date_filter
      begin_range_filter
      end_range_filter
      @pl.terms.where(@match)
    end

    private

    def date_filter
      @match.merge!(effective_date: @effective_date) unless @effective_date.empty?
    end

    def begin_range_filter
      @match.merge!("price_dimension.begin_range": {"$gte": @begin_range}) unless @begin_range.empty?
    end

    def end_range_filter
      @match.merge!("price_dimension.end_range": {"$lte": @end_range}) unless @end_range.empty?
    end

  end
end