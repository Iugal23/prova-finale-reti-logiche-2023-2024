-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 373;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (11,0,177,0,171,0,183,0,119,0,157,0,111,0,53,0,149,0,202,0,36,0,0,0,168,0,160,0,95,0,40,0,38,0,222,0,29,0,151,0,26,0,136,0,68,0,122,0,255,0,191,0,35,0,245,0,232,0,50,0,52,0,215,0,167,0,114,0,0,0,132,0,218,0,228,0,23,0,13,0,20,0,0,0,109,0,14,0,0,0,28,0,57,0,30,0,168,0,35,0,174,0,0,0,83,0,181,0,188,0,220,0,33,0,11,0,244,0,0,0,156,0,10,0,0,0,0,0,0,0,0,0,170,0,109,0,26,0,195,0,0,0,0,0,246,0,246,0,0,0,0,0,0,0,53,0,147,0,115,0,0,0,166,0,187,0,61,0,194,0,0,0,38,0,245,0,129,0,0,0,0,0,0,0,0,0,207,0,133,0,161,0,104,0,234,0,194,0,27,0,21,0,0,0,120,0,17,0,46,0,14,0,0,0,17,0,0,0,0,0,149,0,206,0,188,0,118,0,145,0,60,0,10,0,0,0,0,0,21,0,0,0,172,0,33,0,0,0,2,0,49,0,199,0,24,0,223,0,2,0,116,0,94,0,16,0,176,0,45,0,79,0,41,0,47,0,0,0,23,0,124,0,25,0,229,0,0,0,0,0,100,0,191,0,240,0,0,0,146,0,195,0,212,0,6,0,9,0,149,0,108,0,195,0,198,0,64,0,172,0,159,0,152,0,253,0,108,0,19,0,56,0,0,0,117,0,7,0,164,0,136,0,127,0,91,0,231,0,135,0,132,0,149,0,19,0,33,0,140,0,131,0,163,0,14,0,252,0,42,0,148,0,73,0,43,0,115,0,205,0,107,0,80,0,197,0,0,0,239,0,85,0,239,0,35,0,81,0,0,0,214,0,0,0,0,0,224,0,0,0,195,0,208,0,0,0,56,0,111,0,0,0,85,0,195,0,0,0,136,0,0,0,204,0,100,0,35,0,152,0,19,0,227,0,49,0,19,0,0,0,243,0,211,0,237,0,65,0,138,0,178,0,179,0,70,0,226,0,115,0,0,0,94,0,121,0,156,0,56,0,78,0,162,0,0,0,140,0,217,0,91,0,53,0,0,0,99,0,27,0,225,0,111,0,0,0,118,0,135,0,244,0,0,0,206,0,0,0,229,0,1,0,215,0,0,0,182,0,155,0,28,0,149,0,56,0,87,0,0,0,230,0,77,0,201,0,95,0,0,0,0,0,74,0,183,0,0,0,88,0,204,0,226,0,0,0,20,0,0,0,237,0,201,0,0,0,12,0,152,0,0,0,70,0,41,0,0,0,0,0,0,0,221,0,96,0,205,0,147,0,0,0,94,0,97,0,55,0,253,0,0,0,217,0,83,0,41,0,14,0,150,0,83,0,0,0,56,0,0,0,241,0,24,0,73,0,99,0,99,0,0,0,175,0,179,0,160,0,216,0,58,0,0,0,227,0,91,0,251,0,98,0,90,0,0,0,223,0,184,0,11,0,0,0,0,0,125,0,53,0,184,0,1,0,0,0,0,0,112,0,234,0,109,0,0,0,0,0,0,0,45,0,45,0,0,0,235,0,79,0,0,0,0,0,221,0,90,0,4,0,0,0,81,0,194,0,115,0,60,0,27,0,204,0,79,0,18,0,181,0,206,0,106,0,52,0);
signal scenario_full  : scenario_type := (11,31,177,31,171,31,183,31,119,31,157,31,111,31,53,31,149,31,202,31,36,31,36,30,168,31,160,31,95,31,40,31,38,31,222,31,29,31,151,31,26,31,136,31,68,31,122,31,255,31,191,31,35,31,245,31,232,31,50,31,52,31,215,31,167,31,114,31,114,30,132,31,218,31,228,31,23,31,13,31,20,31,20,30,109,31,14,31,14,30,28,31,57,31,30,31,168,31,35,31,174,31,174,30,83,31,181,31,188,31,220,31,33,31,11,31,244,31,244,30,156,31,10,31,10,30,10,29,10,28,10,27,170,31,109,31,26,31,195,31,195,30,195,29,246,31,246,31,246,30,246,29,246,28,53,31,147,31,115,31,115,30,166,31,187,31,61,31,194,31,194,30,38,31,245,31,129,31,129,30,129,29,129,28,129,27,207,31,133,31,161,31,104,31,234,31,194,31,27,31,21,31,21,30,120,31,17,31,46,31,14,31,14,30,17,31,17,30,17,29,149,31,206,31,188,31,118,31,145,31,60,31,10,31,10,30,10,29,21,31,21,30,172,31,33,31,33,30,2,31,49,31,199,31,24,31,223,31,2,31,116,31,94,31,16,31,176,31,45,31,79,31,41,31,47,31,47,30,23,31,124,31,25,31,229,31,229,30,229,29,100,31,191,31,240,31,240,30,146,31,195,31,212,31,6,31,9,31,149,31,108,31,195,31,198,31,64,31,172,31,159,31,152,31,253,31,108,31,19,31,56,31,56,30,117,31,7,31,164,31,136,31,127,31,91,31,231,31,135,31,132,31,149,31,19,31,33,31,140,31,131,31,163,31,14,31,252,31,42,31,148,31,73,31,43,31,115,31,205,31,107,31,80,31,197,31,197,30,239,31,85,31,239,31,35,31,81,31,81,30,214,31,214,30,214,29,224,31,224,30,195,31,208,31,208,30,56,31,111,31,111,30,85,31,195,31,195,30,136,31,136,30,204,31,100,31,35,31,152,31,19,31,227,31,49,31,19,31,19,30,243,31,211,31,237,31,65,31,138,31,178,31,179,31,70,31,226,31,115,31,115,30,94,31,121,31,156,31,56,31,78,31,162,31,162,30,140,31,217,31,91,31,53,31,53,30,99,31,27,31,225,31,111,31,111,30,118,31,135,31,244,31,244,30,206,31,206,30,229,31,1,31,215,31,215,30,182,31,155,31,28,31,149,31,56,31,87,31,87,30,230,31,77,31,201,31,95,31,95,30,95,29,74,31,183,31,183,30,88,31,204,31,226,31,226,30,20,31,20,30,237,31,201,31,201,30,12,31,152,31,152,30,70,31,41,31,41,30,41,29,41,28,221,31,96,31,205,31,147,31,147,30,94,31,97,31,55,31,253,31,253,30,217,31,83,31,41,31,14,31,150,31,83,31,83,30,56,31,56,30,241,31,24,31,73,31,99,31,99,31,99,30,175,31,179,31,160,31,216,31,58,31,58,30,227,31,91,31,251,31,98,31,90,31,90,30,223,31,184,31,11,31,11,30,11,29,125,31,53,31,184,31,1,31,1,30,1,29,112,31,234,31,109,31,109,30,109,29,109,28,45,31,45,31,45,30,235,31,79,31,79,30,79,29,221,31,90,31,4,31,4,30,81,31,194,31,115,31,60,31,27,31,204,31,79,31,18,31,181,31,206,31,106,31,52,31);

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
