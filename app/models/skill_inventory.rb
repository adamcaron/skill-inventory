require 'yaml/store'
require_relative 'skill'

class SkillInventory
  def self.create(skill)
    database.transaction do
      database['skills'] ||= []
      database['skills'] ||= 0
      database['total'] += 1
      database['skills'] << { "id" => database['total'], "title" => skill[:title], "description" => skill[:description] }
    end
  end

  def self.database
    @database ||= YAML::Store.new("db/skill_inventory")
  end

  def self.raw_skills
    database.transaction do
      database['skills'] || []
    end
  end

  def self.all
    raw_skills.map { |data| Skill.new(data) }
  end

  def self.raw_skill(id)
    raw_skills.find { |skill| skill["id"] == id }
  end

  def self.find(id)
    Skill.new(raw_skill(id))
  end

  def self.update(id, skill)
    database.transaction do
      target = database["skills"].find { |data| data["id"] == id }
      target["title"] = skill[:title]
      target["description"] = skill[:description]
    end
  end
end
