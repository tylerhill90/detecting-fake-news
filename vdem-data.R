library(vdemdata)

# Retrieve data for world map of gov misinfo and assign globally
df_govs <- vdem %>% 
  select(
    country_name,
    year,
    v2mecenefm_mean,    # Government media censorship
    v2smgovdom_mean,    # Government dissemination of false information domestic
    v2smgovab_mean,     # Government dissemination of false information abroad
    v2smpardom_mean,    # Party dissemination of false information domestic
    v2smparab_mean,     # Party dissemination of false information abroad
    v2smfordom_mean     # Foreign governments dissemination of false information
  ) %>% 
  filter(year %in% 2000:2020)

write.csv(df_govs, "./shiny-app/vdem.csv", row.names = FALSE)