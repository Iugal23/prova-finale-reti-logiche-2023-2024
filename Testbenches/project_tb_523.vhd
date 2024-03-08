-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_523 is
end project_tb_523;

architecture project_tb_arch_523 of project_tb_523 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 396;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (87,0,110,0,9,0,38,0,66,0,78,0,79,0,57,0,108,0,75,0,0,0,188,0,214,0,36,0,199,0,223,0,154,0,72,0,40,0,142,0,156,0,0,0,195,0,10,0,0,0,0,0,33,0,0,0,42,0,209,0,0,0,0,0,129,0,184,0,102,0,150,0,0,0,229,0,255,0,0,0,225,0,0,0,0,0,156,0,157,0,9,0,218,0,108,0,4,0,0,0,0,0,0,0,115,0,147,0,30,0,70,0,216,0,215,0,208,0,0,0,84,0,171,0,154,0,247,0,240,0,196,0,238,0,41,0,0,0,64,0,0,0,8,0,94,0,31,0,228,0,68,0,87,0,187,0,181,0,47,0,75,0,0,0,232,0,69,0,36,0,209,0,0,0,0,0,114,0,84,0,75,0,70,0,206,0,89,0,23,0,221,0,205,0,4,0,101,0,211,0,0,0,12,0,200,0,200,0,66,0,16,0,0,0,73,0,13,0,161,0,0,0,225,0,198,0,163,0,211,0,0,0,0,0,148,0,198,0,204,0,0,0,243,0,0,0,0,0,0,0,38,0,255,0,178,0,0,0,180,0,0,0,192,0,36,0,16,0,126,0,17,0,2,0,48,0,1,0,181,0,2,0,89,0,0,0,7,0,33,0,153,0,34,0,127,0,27,0,161,0,161,0,0,0,250,0,42,0,169,0,44,0,237,0,35,0,129,0,182,0,41,0,0,0,192,0,55,0,113,0,0,0,0,0,106,0,0,0,10,0,108,0,220,0,129,0,84,0,84,0,88,0,98,0,173,0,220,0,0,0,192,0,210,0,0,0,68,0,0,0,182,0,132,0,154,0,188,0,0,0,240,0,9,0,178,0,74,0,0,0,26,0,0,0,125,0,0,0,183,0,137,0,139,0,0,0,0,0,35,0,0,0,186,0,0,0,134,0,0,0,158,0,0,0,179,0,114,0,155,0,127,0,234,0,0,0,145,0,92,0,14,0,253,0,52,0,0,0,166,0,181,0,96,0,0,0,49,0,239,0,0,0,28,0,224,0,0,0,153,0,141,0,61,0,35,0,0,0,6,0,0,0,209,0,102,0,119,0,54,0,67,0,13,0,0,0,225,0,182,0,192,0,95,0,55,0,160,0,21,0,187,0,71,0,0,0,49,0,221,0,118,0,240,0,97,0,174,0,164,0,88,0,177,0,0,0,114,0,116,0,35,0,42,0,72,0,0,0,241,0,0,0,233,0,0,0,232,0,156,0,119,0,205,0,146,0,101,0,28,0,175,0,112,0,138,0,128,0,221,0,125,0,0,0,232,0,73,0,0,0,0,0,0,0,0,0,207,0,253,0,43,0,55,0,216,0,110,0,91,0,132,0,110,0,71,0,0,0,252,0,178,0,71,0,93,0,102,0,218,0,39,0,59,0,188,0,0,0,226,0,195,0,136,0,0,0,132,0,0,0,201,0,106,0,162,0,212,0,205,0,84,0,155,0,46,0,229,0,10,0,202,0,19,0,16,0,214,0,94,0,0,0,0,0,167,0,198,0,244,0,107,0,252,0,140,0,0,0,113,0,82,0,17,0,51,0,5,0,32,0,57,0,0,0,0,0,198,0,0,0,196,0,129,0,93,0,235,0,125,0,0,0,123,0,127,0,0,0,126,0,0,0,0,0,153,0,96,0,250,0,0,0,170,0,65,0,218,0,19,0,27,0,241,0,0,0,240,0,67,0,137,0,147,0,84,0,0,0,0,0,164,0,144,0,99,0,0,0,131,0,23,0);
signal scenario_full  : scenario_type := (87,31,110,31,9,31,38,31,66,31,78,31,79,31,57,31,108,31,75,31,75,30,188,31,214,31,36,31,199,31,223,31,154,31,72,31,40,31,142,31,156,31,156,30,195,31,10,31,10,30,10,29,33,31,33,30,42,31,209,31,209,30,209,29,129,31,184,31,102,31,150,31,150,30,229,31,255,31,255,30,225,31,225,30,225,29,156,31,157,31,9,31,218,31,108,31,4,31,4,30,4,29,4,28,115,31,147,31,30,31,70,31,216,31,215,31,208,31,208,30,84,31,171,31,154,31,247,31,240,31,196,31,238,31,41,31,41,30,64,31,64,30,8,31,94,31,31,31,228,31,68,31,87,31,187,31,181,31,47,31,75,31,75,30,232,31,69,31,36,31,209,31,209,30,209,29,114,31,84,31,75,31,70,31,206,31,89,31,23,31,221,31,205,31,4,31,101,31,211,31,211,30,12,31,200,31,200,31,66,31,16,31,16,30,73,31,13,31,161,31,161,30,225,31,198,31,163,31,211,31,211,30,211,29,148,31,198,31,204,31,204,30,243,31,243,30,243,29,243,28,38,31,255,31,178,31,178,30,180,31,180,30,192,31,36,31,16,31,126,31,17,31,2,31,48,31,1,31,181,31,2,31,89,31,89,30,7,31,33,31,153,31,34,31,127,31,27,31,161,31,161,31,161,30,250,31,42,31,169,31,44,31,237,31,35,31,129,31,182,31,41,31,41,30,192,31,55,31,113,31,113,30,113,29,106,31,106,30,10,31,108,31,220,31,129,31,84,31,84,31,88,31,98,31,173,31,220,31,220,30,192,31,210,31,210,30,68,31,68,30,182,31,132,31,154,31,188,31,188,30,240,31,9,31,178,31,74,31,74,30,26,31,26,30,125,31,125,30,183,31,137,31,139,31,139,30,139,29,35,31,35,30,186,31,186,30,134,31,134,30,158,31,158,30,179,31,114,31,155,31,127,31,234,31,234,30,145,31,92,31,14,31,253,31,52,31,52,30,166,31,181,31,96,31,96,30,49,31,239,31,239,30,28,31,224,31,224,30,153,31,141,31,61,31,35,31,35,30,6,31,6,30,209,31,102,31,119,31,54,31,67,31,13,31,13,30,225,31,182,31,192,31,95,31,55,31,160,31,21,31,187,31,71,31,71,30,49,31,221,31,118,31,240,31,97,31,174,31,164,31,88,31,177,31,177,30,114,31,116,31,35,31,42,31,72,31,72,30,241,31,241,30,233,31,233,30,232,31,156,31,119,31,205,31,146,31,101,31,28,31,175,31,112,31,138,31,128,31,221,31,125,31,125,30,232,31,73,31,73,30,73,29,73,28,73,27,207,31,253,31,43,31,55,31,216,31,110,31,91,31,132,31,110,31,71,31,71,30,252,31,178,31,71,31,93,31,102,31,218,31,39,31,59,31,188,31,188,30,226,31,195,31,136,31,136,30,132,31,132,30,201,31,106,31,162,31,212,31,205,31,84,31,155,31,46,31,229,31,10,31,202,31,19,31,16,31,214,31,94,31,94,30,94,29,167,31,198,31,244,31,107,31,252,31,140,31,140,30,113,31,82,31,17,31,51,31,5,31,32,31,57,31,57,30,57,29,198,31,198,30,196,31,129,31,93,31,235,31,125,31,125,30,123,31,127,31,127,30,126,31,126,30,126,29,153,31,96,31,250,31,250,30,170,31,65,31,218,31,19,31,27,31,241,31,241,30,240,31,67,31,137,31,147,31,84,31,84,30,84,29,164,31,144,31,99,31,99,30,131,31,23,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
