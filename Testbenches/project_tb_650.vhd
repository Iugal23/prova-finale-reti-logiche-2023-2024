-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_650 is
end project_tb_650;

architecture project_tb_arch_650 of project_tb_650 is
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

constant SCENARIO_LENGTH : integer := 343;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (229,0,0,0,158,0,231,0,240,0,0,0,169,0,0,0,95,0,52,0,0,0,212,0,185,0,204,0,0,0,0,0,211,0,0,0,177,0,150,0,147,0,46,0,40,0,48,0,0,0,36,0,67,0,175,0,0,0,0,0,215,0,0,0,78,0,55,0,0,0,166,0,33,0,9,0,110,0,0,0,52,0,27,0,189,0,191,0,88,0,232,0,169,0,0,0,173,0,198,0,0,0,222,0,147,0,181,0,30,0,104,0,0,0,25,0,180,0,27,0,8,0,46,0,148,0,0,0,0,0,218,0,130,0,192,0,174,0,195,0,220,0,229,0,234,0,144,0,28,0,244,0,152,0,212,0,236,0,141,0,237,0,0,0,250,0,242,0,120,0,59,0,8,0,201,0,110,0,65,0,99,0,235,0,0,0,215,0,69,0,0,0,252,0,218,0,226,0,169,0,136,0,114,0,0,0,0,0,213,0,192,0,189,0,157,0,0,0,23,0,0,0,184,0,226,0,6,0,0,0,188,0,13,0,0,0,93,0,156,0,254,0,0,0,13,0,73,0,61,0,103,0,79,0,0,0,4,0,222,0,88,0,211,0,42,0,216,0,93,0,0,0,56,0,3,0,245,0,38,0,142,0,139,0,0,0,0,0,33,0,136,0,0,0,0,0,131,0,21,0,18,0,172,0,13,0,106,0,77,0,54,0,98,0,46,0,159,0,187,0,153,0,208,0,189,0,31,0,79,0,211,0,0,0,251,0,0,0,0,0,147,0,177,0,168,0,42,0,253,0,38,0,224,0,150,0,23,0,0,0,224,0,0,0,18,0,172,0,254,0,0,0,142,0,0,0,207,0,34,0,111,0,46,0,0,0,39,0,167,0,164,0,77,0,57,0,0,0,87,0,0,0,4,0,0,0,197,0,166,0,0,0,209,0,182,0,212,0,245,0,55,0,77,0,3,0,117,0,246,0,0,0,63,0,16,0,109,0,82,0,122,0,29,0,6,0,0,0,25,0,68,0,0,0,199,0,73,0,248,0,2,0,77,0,251,0,55,0,18,0,0,0,135,0,107,0,159,0,222,0,104,0,0,0,180,0,197,0,171,0,56,0,161,0,231,0,0,0,0,0,180,0,27,0,165,0,0,0,246,0,119,0,20,0,0,0,217,0,236,0,38,0,0,0,186,0,56,0,59,0,150,0,0,0,101,0,0,0,243,0,90,0,222,0,128,0,131,0,28,0,91,0,0,0,96,0,0,0,143,0,214,0,65,0,201,0,0,0,78,0,0,0,0,0,204,0,222,0,112,0,139,0,0,0,244,0,133,0,0,0,41,0,253,0,161,0,0,0,42,0,167,0,235,0,139,0,0,0,0,0,0,0,236,0,70,0,7,0,121,0,5,0,0,0,175,0,174,0,65,0,70,0,48,0,166,0,178,0,39,0,29,0,4,0,68,0,152,0,248,0,254,0,147,0,32,0,122,0,214,0,0,0,132,0,35,0,0,0,157,0,208,0,0,0,112,0,93,0,95,0,0,0,195,0,84,0);
signal scenario_full  : scenario_type := (229,31,229,30,158,31,231,31,240,31,240,30,169,31,169,30,95,31,52,31,52,30,212,31,185,31,204,31,204,30,204,29,211,31,211,30,177,31,150,31,147,31,46,31,40,31,48,31,48,30,36,31,67,31,175,31,175,30,175,29,215,31,215,30,78,31,55,31,55,30,166,31,33,31,9,31,110,31,110,30,52,31,27,31,189,31,191,31,88,31,232,31,169,31,169,30,173,31,198,31,198,30,222,31,147,31,181,31,30,31,104,31,104,30,25,31,180,31,27,31,8,31,46,31,148,31,148,30,148,29,218,31,130,31,192,31,174,31,195,31,220,31,229,31,234,31,144,31,28,31,244,31,152,31,212,31,236,31,141,31,237,31,237,30,250,31,242,31,120,31,59,31,8,31,201,31,110,31,65,31,99,31,235,31,235,30,215,31,69,31,69,30,252,31,218,31,226,31,169,31,136,31,114,31,114,30,114,29,213,31,192,31,189,31,157,31,157,30,23,31,23,30,184,31,226,31,6,31,6,30,188,31,13,31,13,30,93,31,156,31,254,31,254,30,13,31,73,31,61,31,103,31,79,31,79,30,4,31,222,31,88,31,211,31,42,31,216,31,93,31,93,30,56,31,3,31,245,31,38,31,142,31,139,31,139,30,139,29,33,31,136,31,136,30,136,29,131,31,21,31,18,31,172,31,13,31,106,31,77,31,54,31,98,31,46,31,159,31,187,31,153,31,208,31,189,31,31,31,79,31,211,31,211,30,251,31,251,30,251,29,147,31,177,31,168,31,42,31,253,31,38,31,224,31,150,31,23,31,23,30,224,31,224,30,18,31,172,31,254,31,254,30,142,31,142,30,207,31,34,31,111,31,46,31,46,30,39,31,167,31,164,31,77,31,57,31,57,30,87,31,87,30,4,31,4,30,197,31,166,31,166,30,209,31,182,31,212,31,245,31,55,31,77,31,3,31,117,31,246,31,246,30,63,31,16,31,109,31,82,31,122,31,29,31,6,31,6,30,25,31,68,31,68,30,199,31,73,31,248,31,2,31,77,31,251,31,55,31,18,31,18,30,135,31,107,31,159,31,222,31,104,31,104,30,180,31,197,31,171,31,56,31,161,31,231,31,231,30,231,29,180,31,27,31,165,31,165,30,246,31,119,31,20,31,20,30,217,31,236,31,38,31,38,30,186,31,56,31,59,31,150,31,150,30,101,31,101,30,243,31,90,31,222,31,128,31,131,31,28,31,91,31,91,30,96,31,96,30,143,31,214,31,65,31,201,31,201,30,78,31,78,30,78,29,204,31,222,31,112,31,139,31,139,30,244,31,133,31,133,30,41,31,253,31,161,31,161,30,42,31,167,31,235,31,139,31,139,30,139,29,139,28,236,31,70,31,7,31,121,31,5,31,5,30,175,31,174,31,65,31,70,31,48,31,166,31,178,31,39,31,29,31,4,31,68,31,152,31,248,31,254,31,147,31,32,31,122,31,214,31,214,30,132,31,35,31,35,30,157,31,208,31,208,30,112,31,93,31,95,31,95,30,195,31,84,31);

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
