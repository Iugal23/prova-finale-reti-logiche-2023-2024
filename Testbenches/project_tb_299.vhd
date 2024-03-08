-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_299 is
end project_tb_299;

architecture project_tb_arch_299 of project_tb_299 is
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

constant SCENARIO_LENGTH : integer := 478;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (31,0,123,0,45,0,71,0,190,0,230,0,132,0,228,0,229,0,1,0,33,0,202,0,75,0,0,0,0,0,31,0,117,0,16,0,95,0,42,0,48,0,55,0,46,0,69,0,251,0,253,0,138,0,158,0,148,0,197,0,12,0,82,0,0,0,0,0,70,0,205,0,28,0,211,0,168,0,79,0,94,0,110,0,0,0,120,0,134,0,192,0,0,0,37,0,0,0,251,0,147,0,85,0,29,0,0,0,52,0,54,0,246,0,83,0,66,0,92,0,0,0,211,0,221,0,93,0,124,0,43,0,40,0,1,0,182,0,119,0,214,0,0,0,236,0,205,0,78,0,219,0,216,0,0,0,152,0,128,0,220,0,192,0,227,0,171,0,116,0,122,0,63,0,227,0,70,0,161,0,10,0,117,0,103,0,17,0,0,0,46,0,31,0,246,0,172,0,0,0,35,0,0,0,0,0,51,0,63,0,25,0,0,0,0,0,0,0,0,0,78,0,58,0,129,0,41,0,236,0,49,0,39,0,237,0,55,0,236,0,177,0,0,0,144,0,146,0,18,0,0,0,32,0,0,0,185,0,62,0,44,0,0,0,112,0,131,0,230,0,123,0,110,0,139,0,158,0,0,0,81,0,186,0,222,0,129,0,172,0,19,0,138,0,163,0,0,0,90,0,228,0,0,0,11,0,161,0,176,0,114,0,144,0,108,0,0,0,0,0,38,0,52,0,162,0,223,0,30,0,43,0,64,0,175,0,66,0,226,0,201,0,0,0,182,0,201,0,174,0,0,0,77,0,0,0,68,0,53,0,235,0,64,0,0,0,215,0,108,0,202,0,97,0,0,0,0,0,191,0,213,0,0,0,0,0,196,0,183,0,172,0,75,0,46,0,0,0,0,0,137,0,190,0,0,0,0,0,253,0,181,0,161,0,0,0,0,0,79,0,0,0,0,0,59,0,189,0,0,0,226,0,0,0,0,0,141,0,204,0,175,0,223,0,192,0,42,0,244,0,206,0,46,0,0,0,0,0,204,0,99,0,11,0,174,0,172,0,220,0,0,0,82,0,109,0,108,0,189,0,0,0,123,0,194,0,161,0,174,0,0,0,190,0,242,0,0,0,132,0,0,0,94,0,0,0,187,0,218,0,181,0,160,0,0,0,15,0,94,0,0,0,68,0,0,0,168,0,145,0,227,0,100,0,52,0,120,0,41,0,86,0,13,0,165,0,238,0,163,0,173,0,248,0,47,0,0,0,83,0,118,0,81,0,102,0,0,0,73,0,138,0,69,0,0,0,223,0,42,0,148,0,217,0,159,0,0,0,190,0,123,0,170,0,164,0,200,0,51,0,166,0,112,0,153,0,0,0,42,0,160,0,22,0,0,0,0,0,225,0,158,0,0,0,53,0,35,0,218,0,12,0,32,0,162,0,32,0,0,0,58,0,218,0,0,0,0,0,0,0,70,0,14,0,78,0,0,0,169,0,47,0,184,0,125,0,0,0,191,0,142,0,109,0,89,0,140,0,133,0,64,0,78,0,6,0,252,0,131,0,0,0,107,0,0,0,9,0,164,0,55,0,0,0,130,0,0,0,170,0,77,0,115,0,126,0,17,0,166,0,0,0,119,0,56,0,140,0,92,0,92,0,213,0,0,0,130,0,150,0,123,0,170,0,247,0,0,0,0,0,44,0,40,0,21,0,251,0,83,0,0,0,0,0,0,0,216,0,0,0,3,0,133,0,158,0,0,0,196,0,175,0,69,0,0,0,9,0,135,0,211,0,196,0,209,0,149,0,94,0,0,0,217,0,0,0,150,0,177,0,32,0,67,0,148,0,0,0,121,0,0,0,241,0,231,0,63,0,4,0,227,0,226,0,243,0,121,0,172,0,59,0,242,0,0,0,115,0,0,0,176,0,168,0,0,0,2,0,42,0,233,0,106,0,76,0,150,0,201,0,159,0,0,0,129,0,30,0,196,0,30,0,0,0,43,0,161,0,230,0,160,0,218,0,141,0,1,0,186,0,75,0,0,0,237,0,166,0,14,0,138,0,0,0,12,0,74,0,4,0,0,0,73,0,0,0,1,0,186,0,211,0,84,0,0,0,188,0,17,0,8,0,0,0,106,0,207,0,72,0,99,0,0,0,56,0);
signal scenario_full  : scenario_type := (31,31,123,31,45,31,71,31,190,31,230,31,132,31,228,31,229,31,1,31,33,31,202,31,75,31,75,30,75,29,31,31,117,31,16,31,95,31,42,31,48,31,55,31,46,31,69,31,251,31,253,31,138,31,158,31,148,31,197,31,12,31,82,31,82,30,82,29,70,31,205,31,28,31,211,31,168,31,79,31,94,31,110,31,110,30,120,31,134,31,192,31,192,30,37,31,37,30,251,31,147,31,85,31,29,31,29,30,52,31,54,31,246,31,83,31,66,31,92,31,92,30,211,31,221,31,93,31,124,31,43,31,40,31,1,31,182,31,119,31,214,31,214,30,236,31,205,31,78,31,219,31,216,31,216,30,152,31,128,31,220,31,192,31,227,31,171,31,116,31,122,31,63,31,227,31,70,31,161,31,10,31,117,31,103,31,17,31,17,30,46,31,31,31,246,31,172,31,172,30,35,31,35,30,35,29,51,31,63,31,25,31,25,30,25,29,25,28,25,27,78,31,58,31,129,31,41,31,236,31,49,31,39,31,237,31,55,31,236,31,177,31,177,30,144,31,146,31,18,31,18,30,32,31,32,30,185,31,62,31,44,31,44,30,112,31,131,31,230,31,123,31,110,31,139,31,158,31,158,30,81,31,186,31,222,31,129,31,172,31,19,31,138,31,163,31,163,30,90,31,228,31,228,30,11,31,161,31,176,31,114,31,144,31,108,31,108,30,108,29,38,31,52,31,162,31,223,31,30,31,43,31,64,31,175,31,66,31,226,31,201,31,201,30,182,31,201,31,174,31,174,30,77,31,77,30,68,31,53,31,235,31,64,31,64,30,215,31,108,31,202,31,97,31,97,30,97,29,191,31,213,31,213,30,213,29,196,31,183,31,172,31,75,31,46,31,46,30,46,29,137,31,190,31,190,30,190,29,253,31,181,31,161,31,161,30,161,29,79,31,79,30,79,29,59,31,189,31,189,30,226,31,226,30,226,29,141,31,204,31,175,31,223,31,192,31,42,31,244,31,206,31,46,31,46,30,46,29,204,31,99,31,11,31,174,31,172,31,220,31,220,30,82,31,109,31,108,31,189,31,189,30,123,31,194,31,161,31,174,31,174,30,190,31,242,31,242,30,132,31,132,30,94,31,94,30,187,31,218,31,181,31,160,31,160,30,15,31,94,31,94,30,68,31,68,30,168,31,145,31,227,31,100,31,52,31,120,31,41,31,86,31,13,31,165,31,238,31,163,31,173,31,248,31,47,31,47,30,83,31,118,31,81,31,102,31,102,30,73,31,138,31,69,31,69,30,223,31,42,31,148,31,217,31,159,31,159,30,190,31,123,31,170,31,164,31,200,31,51,31,166,31,112,31,153,31,153,30,42,31,160,31,22,31,22,30,22,29,225,31,158,31,158,30,53,31,35,31,218,31,12,31,32,31,162,31,32,31,32,30,58,31,218,31,218,30,218,29,218,28,70,31,14,31,78,31,78,30,169,31,47,31,184,31,125,31,125,30,191,31,142,31,109,31,89,31,140,31,133,31,64,31,78,31,6,31,252,31,131,31,131,30,107,31,107,30,9,31,164,31,55,31,55,30,130,31,130,30,170,31,77,31,115,31,126,31,17,31,166,31,166,30,119,31,56,31,140,31,92,31,92,31,213,31,213,30,130,31,150,31,123,31,170,31,247,31,247,30,247,29,44,31,40,31,21,31,251,31,83,31,83,30,83,29,83,28,216,31,216,30,3,31,133,31,158,31,158,30,196,31,175,31,69,31,69,30,9,31,135,31,211,31,196,31,209,31,149,31,94,31,94,30,217,31,217,30,150,31,177,31,32,31,67,31,148,31,148,30,121,31,121,30,241,31,231,31,63,31,4,31,227,31,226,31,243,31,121,31,172,31,59,31,242,31,242,30,115,31,115,30,176,31,168,31,168,30,2,31,42,31,233,31,106,31,76,31,150,31,201,31,159,31,159,30,129,31,30,31,196,31,30,31,30,30,43,31,161,31,230,31,160,31,218,31,141,31,1,31,186,31,75,31,75,30,237,31,166,31,14,31,138,31,138,30,12,31,74,31,4,31,4,30,73,31,73,30,1,31,186,31,211,31,84,31,84,30,188,31,17,31,8,31,8,30,106,31,207,31,72,31,99,31,99,30,56,31);

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
