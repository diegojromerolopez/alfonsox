# frozen_string_literal: true

require 'active_record'
require_relative 'babik/queryset'

# Babik module
module Babik

  # @!method included(base)
  # Inject both class methods and instance methods to classes that include this mixin
  # @param [Class] base Class to be extended by mixin.
  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  # All instance methods that are injected to ActiveRecord models
  module InstanceMethods

    # @!method objects(selection_path = nil)
    # Get a queryset that contains the foreign model filtered by the current instance
    # @param [String] selection_path Association name whose objects we want to return.
    # @return [QuerySet] QuerySet with the foreign objects filtered by this instance.
    def objects(selection_path = nil)
      # Instance based deep association
      instance_based_queryset = _objects_with_selection_path(selection_path)
      return instance_based_queryset if instance_based_queryset

      # Basic association to one (belongs_to and has_one)
      to_one_result = self._objects_to_one(selection_path)
      return to_one_result if to_one_result

      # has_many direct relationship (default case)
      self._objects_direct_has_many(selection_path)
    end

    # @!method _objects_with_selection_path(selection_path = nil)
    # Return a QuerySet following the passed selection path.
    # @param [String, Symbol, nil] selection_path Path of relationships that will be used as filter.
    #   If nil, a QuerySet with the current object selected will be returned. Otherwise, a QuerySet with the selection
    #   described by the __ and :: operators.
    # @return [QuerySet] QuerySet for the selection_path passed as parameter.
    def _objects_with_selection_path(selection_path = nil)
      # By default, a nil selection_path means the caller object wants to return a QuerySet with only itself
      return self.class.objects.filter(id: self.id) unless selection_path

      selection_path = selection_path.to_s
      is_a_selection_path = selection_path.include?(Babik::Selection::Config::RELATIONSHIP_SEPARATOR)
      return nil unless is_a_selection_path

      # If the selection path has more than one level deep, we have to build an instance-based query
      selection_path_parts = selection_path.split(Babik::Selection::Config::RELATIONSHIP_SEPARATOR)
      model_i = self.class

      # The aim is to reverse the selection_path both
      # - Relationships will come from target to source.
      # - Direction: the instance will become the filter.

      instance_selection_path_parts = []

      # For each selection path part, invert the association and construct a
      # new selection path for our instance-based query.
      selection_path_parts.each do |association_name_i|
        association_i = model_i.reflect_on_association(association_name_i.to_sym)
        inverse_association_name_i = association_i.options.fetch(:inverse_of)
        instance_selection_path_parts = [inverse_association_name_i] + instance_selection_path_parts
        model_i = association_i.klass
      end

      # Construct a new selection path for our instance-based query
      instance_selection_path = instance_selection_path_parts.join(Babik::Selection::Config::RELATIONSHIP_SEPARATOR)
      model_i.objects.filter("#{instance_selection_path}::id": self.id)
    end

    # @!method _objects_to_one(association_name)
    # Return a QuerySet with the relationship to one
    # @param [String, Symbol] association_name Association name that identifies a relationship with other object.
    # @return [QuerySet, nil] QuerySet based on the association_name, nil if the relationship is not found.
    def _objects_to_one(association_name)
      association_name_to_sym = association_name.to_sym
      association = self.class.reflect_on_association(association_name_to_sym)
      return nil unless association
      # If the relationship is belongs_to or has_one, return a lone ActiveRecord model
      return self.send(association_name_to_sym) if association.belongs_to? || association.has_one?
      nil
    end

    # @!method _objects_direct_has_many(association_name)
    # Return a QuerySet with a direct relationship to many
    # @param [String, Symbol] association_name Association name that identifies a relationship with other objects.
    # @return [QuerySet, nil] QuerySet based on the association_name, nil if the relationship is not found.
    def _objects_direct_has_many(association_name)
      association = self.class.reflect_on_association(association_name.to_sym)
      return nil unless association
      target = Object.const_get(association.class_name)
      begin
        inverse_relationship = association.options.fetch(:inverse_of)
      rescue KeyError => _exception
        raise "Relationship #{association.name} of model #{self.class} has no inverse_of option."
      end
      target.objects.filter("#{inverse_relationship}#{Babik::Selection::Config::RELATIONSHIP_SEPARATOR}id": self.id)
    end
  end

  # All class methods that are injected to ActiveRecord models
  module ClassMethods

    # @!method objects
    # QuerySet for the current model.
    # @return [QuerySet] queryset for the current model.
    def objects
      Babik::QuerySet::Base.new(self)
    end

  end

end


# Include mixin into parent of all active record models (ActiveRecord::Base)
ActiveRecord::Base.send(:include, Babik)
ActiveRecord::Base.send(:include, ActiveModel::AttributeAssignment)
