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
        query_content += "(LEVENSHTEIN(users.first,'#{real_str}') < 3 OR LEVENSHTEIN(last,'#{real_str}') < 3)"

        count += 1
      end
    else
      real_query = query.gsub(/\s+/, "")

      query_content = "(LEVENSHTEIN(users.first,'#{real_query}') < 3 OR LEVENSHTEIN(last,'#{real_query}') < 3)"
    end

    users_relation.where(query_content)
  end

end