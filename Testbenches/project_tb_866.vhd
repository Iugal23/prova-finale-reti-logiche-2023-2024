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

constant SCENARIO_LENGTH : integer := 417;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,41,0,101,0,155,0,31,0,56,0,103,0,120,0,121,0,88,0,140,0,238,0,235,0,119,0,178,0,3,0,191,0,33,0,99,0,180,0,30,0,221,0,209,0,20,0,122,0,27,0,252,0,112,0,181,0,37,0,75,0,0,0,253,0,0,0,121,0,14,0,141,0,15,0,0,0,212,0,114,0,151,0,33,0,0,0,205,0,74,0,29,0,35,0,92,0,153,0,17,0,0,0,246,0,198,0,190,0,101,0,182,0,198,0,217,0,134,0,208,0,0,0,205,0,14,0,190,0,88,0,12,0,220,0,0,0,0,0,0,0,217,0,0,0,159,0,241,0,248,0,44,0,6,0,148,0,234,0,131,0,138,0,111,0,232,0,63,0,206,0,48,0,231,0,149,0,188,0,177,0,0,0,159,0,60,0,210,0,104,0,0,0,99,0,29,0,168,0,179,0,0,0,241,0,0,0,62,0,0,0,217,0,105,0,242,0,82,0,252,0,152,0,0,0,0,0,0,0,241,0,187,0,11,0,0,0,0,0,108,0,133,0,32,0,38,0,148,0,0,0,253,0,40,0,83,0,168,0,104,0,0,0,105,0,23,0,145,0,25,0,32,0,0,0,0,0,73,0,223,0,27,0,0,0,47,0,74,0,96,0,153,0,161,0,184,0,112,0,120,0,140,0,202,0,67,0,180,0,13,0,0,0,0,0,45,0,0,0,224,0,103,0,205,0,0,0,2,0,125,0,224,0,22,0,145,0,6,0,5,0,36,0,0,0,21,0,211,0,0,0,120,0,172,0,123,0,124,0,26,0,246,0,0,0,101,0,68,0,2,0,35,0,0,0,31,0,221,0,0,0,5,0,0,0,0,0,225,0,23,0,131,0,148,0,0,0,0,0,0,0,77,0,160,0,0,0,140,0,134,0,234,0,93,0,230,0,35,0,194,0,118,0,172,0,40,0,44,0,0,0,85,0,181,0,106,0,21,0,103,0,0,0,67,0,193,0,101,0,191,0,0,0,224,0,241,0,88,0,0,0,54,0,2,0,76,0,55,0,34,0,54,0,109,0,43,0,152,0,147,0,0,0,194,0,1,0,190,0,0,0,98,0,186,0,177,0,67,0,0,0,62,0,0,0,200,0,196,0,89,0,38,0,29,0,111,0,132,0,0,0,234,0,124,0,191,0,0,0,0,0,144,0,26,0,189,0,63,0,105,0,84,0,0,0,94,0,167,0,147,0,93,0,89,0,0,0,0,0,81,0,0,0,16,0,126,0,0,0,201,0,0,0,123,0,196,0,0,0,131,0,71,0,249,0,243,0,129,0,0,0,98,0,102,0,0,0,0,0,132,0,0,0,73,0,108,0,7,0,217,0,250,0,220,0,1,0,33,0,197,0,172,0,7,0,2,0,176,0,136,0,192,0,0,0,124,0,0,0,77,0,15,0,50,0,0,0,62,0,20,0,121,0,0,0,126,0,67,0,26,0,129,0,0,0,0,0,36,0,219,0,45,0,135,0,131,0,51,0,146,0,123,0,141,0,1,0,0,0,0,0,196,0,92,0,0,0,40,0,0,0,26,0,30,0,131,0,15,0,234,0,141,0,66,0,174,0,76,0,221,0,0,0,207,0,30,0,255,0,106,0,153,0,25,0,38,0,121,0,87,0,210,0,245,0,226,0,98,0,246,0,155,0,149,0,85,0,17,0,154,0,67,0,250,0,186,0,0,0,0,0,206,0,220,0,245,0,0,0,16,0,20,0,59,0,102,0,33,0,73,0,0,0,109,0,157,0,224,0,0,0,182,0,0,0,151,0,151,0,182,0,233,0,209,0,71,0,244,0,246,0,4,0,78,0,141,0,96,0,0,0,0,0);
signal scenario_full  : scenario_type := (0,0,41,31,101,31,155,31,31,31,56,31,103,31,120,31,121,31,88,31,140,31,238,31,235,31,119,31,178,31,3,31,191,31,33,31,99,31,180,31,30,31,221,31,209,31,20,31,122,31,27,31,252,31,112,31,181,31,37,31,75,31,75,30,253,31,253,30,121,31,14,31,141,31,15,31,15,30,212,31,114,31,151,31,33,31,33,30,205,31,74,31,29,31,35,31,92,31,153,31,17,31,17,30,246,31,198,31,190,31,101,31,182,31,198,31,217,31,134,31,208,31,208,30,205,31,14,31,190,31,88,31,12,31,220,31,220,30,220,29,220,28,217,31,217,30,159,31,241,31,248,31,44,31,6,31,148,31,234,31,131,31,138,31,111,31,232,31,63,31,206,31,48,31,231,31,149,31,188,31,177,31,177,30,159,31,60,31,210,31,104,31,104,30,99,31,29,31,168,31,179,31,179,30,241,31,241,30,62,31,62,30,217,31,105,31,242,31,82,31,252,31,152,31,152,30,152,29,152,28,241,31,187,31,11,31,11,30,11,29,108,31,133,31,32,31,38,31,148,31,148,30,253,31,40,31,83,31,168,31,104,31,104,30,105,31,23,31,145,31,25,31,32,31,32,30,32,29,73,31,223,31,27,31,27,30,47,31,74,31,96,31,153,31,161,31,184,31,112,31,120,31,140,31,202,31,67,31,180,31,13,31,13,30,13,29,45,31,45,30,224,31,103,31,205,31,205,30,2,31,125,31,224,31,22,31,145,31,6,31,5,31,36,31,36,30,21,31,211,31,211,30,120,31,172,31,123,31,124,31,26,31,246,31,246,30,101,31,68,31,2,31,35,31,35,30,31,31,221,31,221,30,5,31,5,30,5,29,225,31,23,31,131,31,148,31,148,30,148,29,148,28,77,31,160,31,160,30,140,31,134,31,234,31,93,31,230,31,35,31,194,31,118,31,172,31,40,31,44,31,44,30,85,31,181,31,106,31,21,31,103,31,103,30,67,31,193,31,101,31,191,31,191,30,224,31,241,31,88,31,88,30,54,31,2,31,76,31,55,31,34,31,54,31,109,31,43,31,152,31,147,31,147,30,194,31,1,31,190,31,190,30,98,31,186,31,177,31,67,31,67,30,62,31,62,30,200,31,196,31,89,31,38,31,29,31,111,31,132,31,132,30,234,31,124,31,191,31,191,30,191,29,144,31,26,31,189,31,63,31,105,31,84,31,84,30,94,31,167,31,147,31,93,31,89,31,89,30,89,29,81,31,81,30,16,31,126,31,126,30,201,31,201,30,123,31,196,31,196,30,131,31,71,31,249,31,243,31,129,31,129,30,98,31,102,31,102,30,102,29,132,31,132,30,73,31,108,31,7,31,217,31,250,31,220,31,1,31,33,31,197,31,172,31,7,31,2,31,176,31,136,31,192,31,192,30,124,31,124,30,77,31,15,31,50,31,50,30,62,31,20,31,121,31,121,30,126,31,67,31,26,31,129,31,129,30,129,29,36,31,219,31,45,31,135,31,131,31,51,31,146,31,123,31,141,31,1,31,1,30,1,29,196,31,92,31,92,30,40,31,40,30,26,31,30,31,131,31,15,31,234,31,141,31,66,31,174,31,76,31,221,31,221,30,207,31,30,31,255,31,106,31,153,31,25,31,38,31,121,31,87,31,210,31,245,31,226,31,98,31,246,31,155,31,149,31,85,31,17,31,154,31,67,31,250,31,186,31,186,30,186,29,206,31,220,31,245,31,245,30,16,31,20,31,59,31,102,31,33,31,73,31,73,30,109,31,157,31,224,31,224,30,182,31,182,30,151,31,151,31,182,31,233,31,209,31,71,31,244,31,246,31,4,31,78,31,141,31,96,31,96,30,96,29);

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
