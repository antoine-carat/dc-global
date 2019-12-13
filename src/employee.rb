require 'nokogiri'
require 'json'
require 'date'
require_relative './bamboo_api'

class Employee
    attr_reader :id

    def initialize(xml)
        @id = xml.attr('id')
        @first_name = xml.xpath("field[@id='firstName']")[0].content
        @last_name = xml.xpath("field[@id='lastName']")[0].content
        @photo_url = xml.xpath("field[@id='photoUrl']")[0].content
        @location = xml.xpath("field[@id='location']")[0].content
        @time_off = []
    end

    def add_time_off(xml)
        start_time = ::Date.parse(xml.xpath('//start')[0].content)
        end_time = ::Date.parse(xml.xpath('//end')[0].content)
        @time_off << (start_time..end_time).to_a
    end

    def to_json
        {
            id: @id,
            first_name: @first_name,
            last_name: @last_name,
            photo_url: @photo_url,
            time_off: @time_off
        }.to_json
    end

    def self.all(ids, bamboo_api)
        all_employees = bamboo_api.get_employees
        employee_time_off = bamboo_api.get_time_off
        # all_employees = File.open("emplyees.xml") { |f| Nokogiri::XML(f) }
        # employee_time_off = File.open("time_off.xml") { |f| Nokogiri::XML(f) }
        our_employees = all_employees.xpath('//employee').select do |employee|
            ids.include?(employee.attr('id'))
        end
        our_employees.map do |employee_xml|
            employee = Employee.new(employee_xml)
            employee_time_off.xpath('//item').select do |time_off|
                time_off_employee_xml = time_off.xpath('employee')[0]
                time_off_employee_xml && time_off_employee_xml.attr('id') == employee.id
            end.each { |time_off_xml| employee.add_time_off(time_off_xml) }
            employee
        end
    end
end
