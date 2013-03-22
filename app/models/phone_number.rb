class PhoneNumber
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validate :real_number

  attr_accessor :number, :npa, :nxx, :line

  # Public: List of currently valid npas/area codes according to
  #         http://en.wikipedia.org/wiki/List_of_North_American_Numbering_Plan_area_codes
  #
  # Returns an Array of Symbols of the 3 digit npas/area codes
  def self.npa
    [201, 202, 203, 205, 206, 207, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219, 224, 225, 227, 228, 229, 231, 234, 239, 240, 248, 250, 251, 252, 253, 254, 256, 260, 262, 267, 269, 270, 272, 274, 276, 281, 283, 301, 302, 303, 304, 305, 307, 308, 309, 310, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 323, 325, 327, 330, 331, 334, 336, 337, 339, 341, 347, 351, 352, 360, 361, 364, 369, 380, 385, 386, 401, 402, 404, 405, 406, 407, 408, 409, 410, 412, 413, 414, 415, 417, 419, 423, 424, 425, 430, 432, 434, 435, 440, 442, 443, 445, 447, 458, 464, 469, 470, 475, 478, 479, 480, 484, 501, 502, 503, 504, 505, 507, 508, 509, 510, 512, 513, 515, 516, 517, 518, 520, 530, 531, 534, 539, 540, 541, 551, 557, 559, 561, 562, 563, 564, 567, 570, 571, 573, 574, 575, 580, 582, 585, 586, 601, 602, 603, 605, 606, 607, 608, 609, 610, 612, 614, 615, 616, 617, 618, 619, 620, 623, 626, 627, 628, 630, 631, 636, 641, 646, 650, 651, 657, 659, 660, 661, 662, 667, 669, 678, 679, 681, 682, 689, 701, 702, 703, 704, 706, 707, 708, 712, 713, 714, 715, 716, 717, 718, 719, 720, 724, 727, 730, 731, 732, 734, 737, 740, 747, 754, 757, 760, 762, 763, 764, 765, 769, 770, 772, 773, 774, 775, 779, 781, 785, 786, 801, 802, 803, 804, 805, 806, 808, 810, 812, 813, 814, 815, 816, 817, 818, 828, 830, 831, 832, 835, 843, 845, 847, 848, 850, 856, 857, 858, 859, 860, 862, 863, 864, 865, 870, 872, 878, 901, 903, 904, 906, 907, 908, 909, 910, 912, 913, 914, 915, 916, 917, 918, 919, 920, 925, 928, 929, 931, 935, 936, 937, 938, 940, 941, 947, 949, 951, 952, 954, 956, 959, 970, 971, 972, 973, 975, 978, 979, 980, 984, 985, 989].map! { |n| n.to_s.to_sym }
  end

  # Public: List of valid nxx which have 2-9 for the first digit,
  #         and 0-9 for the final 2
  #
  # Returns an Array of Symbols of valid 3 digit nxx/exchanges
  def self.nxx
    allNxxs = []
    (2..9).each do |n|
      nxxGroup = []
      100.times do |t|
        newNxx = n * 100 + t
        nxxGroup << newNxx.to_s.to_sym
      end
      allNxxs = allNxxs + nxxGroup
    end
    allNxxs
  end

  # Public: For a given npa, creates a list of npa and valid-nxx combinations
  #
  # npa - String of the 3 digit npa/area code to create the list for
  #
  # Returns an Array of Symbols of the npa and valid-nxx combinations
  def self.nxx_list(npa)
    list = []
    self.nxx.each do |nxx|
      list << (npa.to_s + nxx.to_s).to_sym
    end
    list
  end

  # Public: list of valid lines/last-4-digits
  #
  # Returns an Array of Symbols of all possible 4 digit lines/last-4-digits
  def self.line
    allLines = []
    10000.times do |n|
      allLines << ("%04d" % n).to_sym
    end
    allLines
  end

  # Public: creates a list of 10 digit numbers given an npa and nxx
  #
  # npa - 3 digit String of the npa/area code
  # nxx - 3 digit String of the nxx/exchange
  #
  # Returns an Array of Symbols of all possible numbers in a given npa-nxx
  def self.line_list(npa, nxx)
    list = []
    self.line.each do |line|
      list << (npa.to_s + nxx.to_s + line.to_s).to_sym
    end
    list
  end

  # Public: list of all possible toll free area codes
  #
  # Returns an Array of Symbols of all possible toll free area codes
  def self.toll_free_npa
    [800, 822, 833, 844, 855, 866, 877, 880, 881, 882, 888].map! { |n| n.to_s.to_sym }
  end

  def self.normalize_number(number)
    number.to_s.gsub(/\D/,'')[-10..-1].try :to_sym
  end

  def initialize(number)
    @number = self.class.normalize_number(number.to_s)
    if @number
      @npa  = @number[0..2].to_sym
      @nxx  = @number[3..5].to_sym
      @line = @number[6..9].to_sym
    end
  end

  def persisted?
    false
  end

  def to_param
    number
  end

  def caller_id(options = {})
    Rails.cache.fetch(['caller id', number], expires_in: 3.days, force: options[:force]) do
      retrieve_caller_id
    end
  end

  private

  def retrieve_caller_id
    begin
      Opencnam::Client.new({
        use_ssl: true
      }).phone @number.to_s
    rescue => e
      Rails.logger.error 'opencnam lookup failed'
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end

  def real_number
    errors.add(:number, 'invalid npa/area code')     unless PhoneNumber.npa.include?(npa) || PhoneNumber.toll_free_npa.include?(npa)
    errors.add(:number, 'invalid nxx')               unless PhoneNumber.nxx.include?(nxx) || PhoneNumber.toll_free_npa.include?(npa)
    errors.add(:type,   'number must be 10 digits')  unless number && number.length == 10
  end
end
