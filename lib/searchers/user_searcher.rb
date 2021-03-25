class Searchers::UserSearcher

  def search(users_relation, query)

    users = perform_search(users_relation, query, false)

    # If the result set does not contain any results, we need to loosen up our requirements
    if users.count == 0
      users = perform_search(users_relation, query, true)
    end

    users
  end

  private
  def perform_search(users_relation, query, relaxed)

    if relaxed
      operator = " OR "
    else
      operator = " AND "
    end

    query_content = ""
    if query.split.count > 1
      count = 0
      query.split.each do |str|
        if count > 0
          query_content += operator
        end
        real_str = str.gsub(/\s+/, "")
        query_content += "(to_tsvector('english', users.first) @@ to_tsquery('english', '#{real_str}:*')
                        OR to_tsvector('english', users.last) @@ to_tsquery('english', '#{real_str}:*'))"

        count += 1
      end
    else
      real_query = query.gsub(/\s+/, "")
      query_content = "to_tsvector('english', users.first) @@ to_tsquery('english', '#{real_query}:*')
            OR to_tsvector('english', users.last) @@ to_tsquery('english', '#{real_query}:*')"
    end

    users_relation.where(query_content)
  end

end