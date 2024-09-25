
angular.module('candidature.directives', ['candidature.services', 'bootstrapLightbox'])


.directive("flagIcon", ->
  return {
    restrict: 'E',
    replace: true,
    scope: {
      country: '='
    }
    template: (x, scope) ->
      return '<img class="flag" ng-src="images/flags/' + scope.country + '.png" alt="{{ country }}"/>'
  }
)

.directive('uniqueUserField', (Users) ->
  toId = null
  return {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, elem, attr, ctrl) ->
      scope.isUniqueUserField = (ctrl, value) ->
        if ctrl.toId
          clearTimeout(toId)
        ctrl.toId = setTimeout(() ->
          if(!value)
            return
          Users.getList({search: value}).then((data) ->
              ctrl.$setValidity('uniqueUserField', data.length<1)
          )
        , 200)
      scope.$watch(attr.ngModel, (value, value2) ->
        scope.isUniqueUserField(ctrl, value)
      )
  }
)

.directive('sameValueAs', () ->
    return {
        require: "ngModel",
        scope: {
            otherModelValue: "=sameValueAs"
        },
        link: (scope, element, attributes, ngModel) ->
            ngModel.$validators.sameValueAs = (modelValue) ->
                return modelValue == scope.otherModelValue

            scope.$watch(scope.otherModelValue, (value) ->
                ngModel.$validate();
            )
    }
)