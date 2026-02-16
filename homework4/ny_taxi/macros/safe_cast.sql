{#
    Macro to safely cast columns to target data types.
    
    For BigQuery, this uses SAFE_CAST which returns NULL instead of failing
    when a value cannot be cast to the target type.
    
    This is essential when dealing with external tables where parquet files
    may have inconsistent schemas across different files.
    
    Args:
        column_name: The name of the column to cast
        target_type: The target SQL data type (e.g., 'integer', 'numeric', 'timestamp')
    
    Returns:
        SQL expression that safely casts the column
    
    Example:
        {{ safe_cast('vendorid', 'integer') }} as vendor_id
#}

{% macro safe_cast(column_name, target_type) %}
    safe_cast({{ column_name }} as {{ target_type }})
{% endmacro %}
