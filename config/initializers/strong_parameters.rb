# encoding: UTF-8

ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)
