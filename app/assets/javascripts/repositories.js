Application = window.Application || {}
Application.Repository = {
  selectors: {
    searchForm: '.js-repositories-search-form',
    repositoryResultTemplate: '#repository_template',
    resultsContainer: '.js-repositories-search-results',
  },

  setupSearchForm(){
    this.$searchForm = $(this.selectors.searchForm);
    this.repositoryTemplate = $(this.selectors.repositoryResultTemplate).text();
    this.$resultsContainer = $(this.selectors.resultsContainer)
  },

  setup: function(){
    this.setupSearchForm();
  },

  bindEvents: function(){
    this.$searchForm.on('ajax:success', this.onSearchSuccess.bind(this))
    this.$searchForm.on('ajax:error', this.onSearchFail.bind(this))
  },

  buildTemplate: function(repository){
    return $(Mustache.render(this.repositoryTemplate, repository))
  },

  appendResult: function(repository){
    this.$resultsContainer.append(
      this.buildTemplate(repository)
    )
  },

  onSearchSuccess: function(e, repositories){
    this.$resultsContainer.empty();

    $(repositories).each(function(index, repository){
      this.appendResult(repository);
    }.bind(this))
  },

  onSearchFail: function(e){
    alert('oops, something happened...');
  },

  init: function(){
    this.setup();
    this.bindEvents();
  }
}

$(function(){
  Application.Repository.init();
});


