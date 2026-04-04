module PaginationHelper
  def chunked_pagination(collection, chunk: 10)
    collection ||= []

    current = params[:page].present? ? params[:page].to_i : 1
    current = 1 if current <= 0

    total = collection.respond_to?(:total_pages) ? collection.total_pages.to_i : 1
    total = 1 if total <= 0

    block_start = ((current - 1) / chunk) * chunk + 1
    block_end   = [block_start + chunk - 1, total].min

    prev_page   = current > 1 ? current - 1 : nil
    next_page   = current < total ? current + 1 : nil
    prev_block  = block_start > 1 ? block_start - chunk : nil
    next_block  = block_end < total ? block_end + 1 : nil

    {
      current: current,
      total: total,
      chunk: chunk,
      block_start: block_start,
      block_end: block_end,
      pages: (block_start..block_end).to_a,
      prev_page: prev_page,
      next_page: next_page,
      prev_block: prev_block,
      next_block: next_block
    }
  end
end