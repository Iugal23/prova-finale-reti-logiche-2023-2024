-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_820 is
end project_tb_820;

architecture project_tb_arch_820 of project_tb_820 is
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

constant SCENARIO_LENGTH : integer := 402;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (34,0,244,0,68,0,124,0,121,0,120,0,203,0,247,0,57,0,46,0,0,0,54,0,29,0,225,0,0,0,2,0,160,0,120,0,162,0,142,0,98,0,179,0,28,0,21,0,152,0,175,0,47,0,3,0,125,0,74,0,101,0,243,0,0,0,234,0,218,0,0,0,0,0,251,0,114,0,171,0,221,0,83,0,0,0,82,0,112,0,0,0,79,0,136,0,187,0,231,0,171,0,206,0,59,0,155,0,226,0,74,0,35,0,195,0,0,0,136,0,226,0,221,0,86,0,42,0,142,0,54,0,35,0,91,0,0,0,210,0,0,0,149,0,95,0,128,0,155,0,107,0,0,0,219,0,23,0,91,0,0,0,134,0,82,0,153,0,76,0,140,0,213,0,250,0,37,0,0,0,143,0,0,0,241,0,105,0,250,0,142,0,200,0,110,0,198,0,27,0,156,0,174,0,37,0,61,0,182,0,56,0,96,0,23,0,180,0,223,0,0,0,2,0,67,0,113,0,130,0,111,0,86,0,21,0,0,0,0,0,0,0,209,0,0,0,65,0,73,0,72,0,0,0,109,0,128,0,0,0,96,0,165,0,29,0,242,0,201,0,158,0,199,0,116,0,21,0,184,0,0,0,190,0,151,0,181,0,110,0,0,0,0,0,254,0,0,0,68,0,216,0,38,0,81,0,243,0,80,0,105,0,50,0,205,0,254,0,144,0,121,0,138,0,0,0,65,0,0,0,238,0,225,0,177,0,30,0,89,0,241,0,213,0,75,0,134,0,250,0,0,0,55,0,0,0,234,0,121,0,0,0,230,0,119,0,152,0,168,0,178,0,67,0,0,0,30,0,0,0,158,0,191,0,0,0,31,0,255,0,203,0,204,0,187,0,176,0,149,0,99,0,0,0,230,0,61,0,220,0,85,0,69,0,244,0,222,0,243,0,116,0,217,0,122,0,0,0,89,0,160,0,121,0,31,0,179,0,226,0,141,0,42,0,93,0,114,0,228,0,17,0,83,0,214,0,221,0,86,0,18,0,67,0,0,0,67,0,148,0,20,0,93,0,0,0,0,0,90,0,0,0,188,0,165,0,228,0,167,0,87,0,209,0,39,0,161,0,31,0,0,0,233,0,170,0,0,0,0,0,243,0,18,0,61,0,132,0,73,0,144,0,24,0,254,0,0,0,239,0,125,0,211,0,0,0,37,0,0,0,64,0,78,0,211,0,45,0,168,0,73,0,250,0,104,0,114,0,8,0,252,0,12,0,7,0,101,0,215,0,209,0,130,0,176,0,99,0,24,0,52,0,12,0,229,0,195,0,47,0,164,0,92,0,33,0,226,0,97,0,182,0,146,0,96,0,111,0,0,0,243,0,0,0,196,0,1,0,107,0,195,0,37,0,112,0,34,0,0,0,198,0,0,0,0,0,240,0,217,0,0,0,162,0,48,0,0,0,52,0,0,0,63,0,5,0,10,0,191,0,170,0,255,0,200,0,0,0,135,0,6,0,102,0,0,0,241,0,87,0,200,0,232,0,207,0,109,0,204,0,11,0,167,0,253,0,203,0,73,0,0,0,139,0,125,0,76,0,76,0,169,0,0,0,193,0,106,0,224,0,136,0,60,0,255,0,78,0,245,0,0,0,196,0,89,0,0,0,172,0,141,0,9,0,233,0,135,0,0,0,116,0,223,0,55,0,246,0,0,0,238,0,124,0,0,0,131,0,67,0,85,0,69,0,0,0,7,0,0,0,181,0,205,0,223,0,0,0,99,0,93,0,0,0,94,0,180,0,114,0,0,0,108,0);
signal scenario_full  : scenario_type := (34,31,244,31,68,31,124,31,121,31,120,31,203,31,247,31,57,31,46,31,46,30,54,31,29,31,225,31,225,30,2,31,160,31,120,31,162,31,142,31,98,31,179,31,28,31,21,31,152,31,175,31,47,31,3,31,125,31,74,31,101,31,243,31,243,30,234,31,218,31,218,30,218,29,251,31,114,31,171,31,221,31,83,31,83,30,82,31,112,31,112,30,79,31,136,31,187,31,231,31,171,31,206,31,59,31,155,31,226,31,74,31,35,31,195,31,195,30,136,31,226,31,221,31,86,31,42,31,142,31,54,31,35,31,91,31,91,30,210,31,210,30,149,31,95,31,128,31,155,31,107,31,107,30,219,31,23,31,91,31,91,30,134,31,82,31,153,31,76,31,140,31,213,31,250,31,37,31,37,30,143,31,143,30,241,31,105,31,250,31,142,31,200,31,110,31,198,31,27,31,156,31,174,31,37,31,61,31,182,31,56,31,96,31,23,31,180,31,223,31,223,30,2,31,67,31,113,31,130,31,111,31,86,31,21,31,21,30,21,29,21,28,209,31,209,30,65,31,73,31,72,31,72,30,109,31,128,31,128,30,96,31,165,31,29,31,242,31,201,31,158,31,199,31,116,31,21,31,184,31,184,30,190,31,151,31,181,31,110,31,110,30,110,29,254,31,254,30,68,31,216,31,38,31,81,31,243,31,80,31,105,31,50,31,205,31,254,31,144,31,121,31,138,31,138,30,65,31,65,30,238,31,225,31,177,31,30,31,89,31,241,31,213,31,75,31,134,31,250,31,250,30,55,31,55,30,234,31,121,31,121,30,230,31,119,31,152,31,168,31,178,31,67,31,67,30,30,31,30,30,158,31,191,31,191,30,31,31,255,31,203,31,204,31,187,31,176,31,149,31,99,31,99,30,230,31,61,31,220,31,85,31,69,31,244,31,222,31,243,31,116,31,217,31,122,31,122,30,89,31,160,31,121,31,31,31,179,31,226,31,141,31,42,31,93,31,114,31,228,31,17,31,83,31,214,31,221,31,86,31,18,31,67,31,67,30,67,31,148,31,20,31,93,31,93,30,93,29,90,31,90,30,188,31,165,31,228,31,167,31,87,31,209,31,39,31,161,31,31,31,31,30,233,31,170,31,170,30,170,29,243,31,18,31,61,31,132,31,73,31,144,31,24,31,254,31,254,30,239,31,125,31,211,31,211,30,37,31,37,30,64,31,78,31,211,31,45,31,168,31,73,31,250,31,104,31,114,31,8,31,252,31,12,31,7,31,101,31,215,31,209,31,130,31,176,31,99,31,24,31,52,31,12,31,229,31,195,31,47,31,164,31,92,31,33,31,226,31,97,31,182,31,146,31,96,31,111,31,111,30,243,31,243,30,196,31,1,31,107,31,195,31,37,31,112,31,34,31,34,30,198,31,198,30,198,29,240,31,217,31,217,30,162,31,48,31,48,30,52,31,52,30,63,31,5,31,10,31,191,31,170,31,255,31,200,31,200,30,135,31,6,31,102,31,102,30,241,31,87,31,200,31,232,31,207,31,109,31,204,31,11,31,167,31,253,31,203,31,73,31,73,30,139,31,125,31,76,31,76,31,169,31,169,30,193,31,106,31,224,31,136,31,60,31,255,31,78,31,245,31,245,30,196,31,89,31,89,30,172,31,141,31,9,31,233,31,135,31,135,30,116,31,223,31,55,31,246,31,246,30,238,31,124,31,124,30,131,31,67,31,85,31,69,31,69,30,7,31,7,30,181,31,205,31,223,31,223,30,99,31,93,31,93,30,94,31,180,31,114,31,114,30,108,31);

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
