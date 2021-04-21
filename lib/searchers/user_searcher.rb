class Searchers::UserSearcher

  def search(users_relation, query)

    users = perform_search(users_relation, query, false)

    # If the result set does not contain any results, we need to loosen up our requirements
    if users.count == 0
      users = perform_search(users_relation, query, true)
    end

    users
  end


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
        real_str_lower = real_str.downcase
        query_content += "(LEVENSHTEIN(users.first,'#{real_str}') < 3 OR LEVENSHTEIN(last,'#{real_str}') < 3) OR (lower(users.first) LIKE '%#{real_str_lower}%' OR lower(users.last) LIKE '%#{real_str_lower}%')"

        count += 1
      end
    else
      real_query = query.gsub(/\s+/, "")
      real_query_lower = real_query.downcase

      query_content = "(LEVENSHTEIN(users.first,'#{real_query}') < 3 OR LEVENSHTEIN(last,'#{real_query}') < 3) OR (lower(users.first) LIKE '%#{real_query_lower}%' OR lower(users.last) LIKE '%#{real_query_lower}%')"
    end

    users_relation.where(query_content)
  end

end