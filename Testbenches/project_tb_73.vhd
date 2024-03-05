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

constant SCENARIO_LENGTH : integer := 409;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (183,0,56,0,83,0,28,0,20,0,221,0,0,0,105,0,0,0,52,0,69,0,125,0,153,0,0,0,95,0,244,0,39,0,223,0,64,0,89,0,110,0,64,0,232,0,224,0,235,0,205,0,0,0,170,0,42,0,118,0,105,0,254,0,0,0,215,0,0,0,111,0,0,0,0,0,96,0,37,0,209,0,0,0,0,0,66,0,255,0,0,0,20,0,67,0,72,0,0,0,110,0,0,0,197,0,227,0,44,0,255,0,117,0,100,0,0,0,0,0,122,0,244,0,30,0,90,0,109,0,213,0,0,0,104,0,177,0,0,0,0,0,76,0,48,0,0,0,189,0,91,0,0,0,149,0,174,0,0,0,187,0,43,0,116,0,223,0,194,0,233,0,254,0,113,0,154,0,69,0,63,0,120,0,0,0,0,0,217,0,87,0,246,0,0,0,219,0,50,0,244,0,6,0,162,0,117,0,91,0,225,0,215,0,0,0,48,0,0,0,188,0,205,0,67,0,137,0,0,0,0,0,101,0,49,0,175,0,40,0,0,0,226,0,142,0,152,0,9,0,11,0,79,0,149,0,23,0,155,0,128,0,51,0,145,0,247,0,184,0,154,0,207,0,156,0,0,0,151,0,174,0,226,0,36,0,225,0,42,0,181,0,24,0,135,0,126,0,131,0,234,0,0,0,0,0,204,0,217,0,219,0,125,0,82,0,26,0,203,0,160,0,19,0,0,0,4,0,154,0,127,0,47,0,0,0,0,0,125,0,97,0,0,0,219,0,0,0,244,0,0,0,237,0,0,0,172,0,109,0,0,0,56,0,132,0,136,0,70,0,235,0,0,0,0,0,57,0,5,0,234,0,0,0,14,0,0,0,68,0,126,0,0,0,149,0,49,0,0,0,217,0,0,0,19,0,240,0,92,0,75,0,248,0,44,0,63,0,138,0,63,0,253,0,218,0,222,0,127,0,20,0,97,0,163,0,0,0,208,0,0,0,17,0,65,0,0,0,100,0,44,0,119,0,149,0,0,0,92,0,0,0,80,0,151,0,33,0,24,0,14,0,134,0,190,0,0,0,201,0,0,0,102,0,0,0,75,0,0,0,74,0,108,0,132,0,97,0,19,0,214,0,80,0,51,0,0,0,71,0,103,0,243,0,126,0,59,0,0,0,0,0,167,0,38,0,208,0,44,0,150,0,192,0,33,0,12,0,204,0,247,0,198,0,202,0,173,0,247,0,169,0,87,0,0,0,194,0,233,0,76,0,142,0,38,0,167,0,13,0,84,0,247,0,206,0,0,0,36,0,250,0,0,0,122,0,174,0,0,0,140,0,0,0,236,0,232,0,0,0,0,0,117,0,144,0,221,0,111,0,73,0,126,0,0,0,49,0,11,0,223,0,0,0,0,0,228,0,48,0,213,0,150,0,186,0,133,0,72,0,217,0,133,0,207,0,169,0,0,0,6,0,26,0,241,0,200,0,61,0,0,0,151,0,67,0,243,0,108,0,27,0,0,0,155,0,72,0,145,0,34,0,199,0,197,0,54,0,0,0,130,0,151,0,0,0,245,0,107,0,187,0,80,0,254,0,127,0,214,0,83,0,0,0,0,0,180,0,198,0,128,0,226,0,11,0,228,0,242,0,21,0,0,0,246,0,38,0,202,0,243,0,158,0,142,0,255,0,105,0,0,0,213,0,139,0,0,0,174,0,0,0,234,0,50,0,19,0,0,0,0,0,0,0,2,0,214,0,0,0,38,0,225,0,42,0,0,0,0,0,83,0,0,0,0,0,35,0,83,0,115,0,186,0,125,0,245,0,129,0,40,0,134,0,10,0,194,0);
signal scenario_full  : scenario_type := (183,31,56,31,83,31,28,31,20,31,221,31,221,30,105,31,105,30,52,31,69,31,125,31,153,31,153,30,95,31,244,31,39,31,223,31,64,31,89,31,110,31,64,31,232,31,224,31,235,31,205,31,205,30,170,31,42,31,118,31,105,31,254,31,254,30,215,31,215,30,111,31,111,30,111,29,96,31,37,31,209,31,209,30,209,29,66,31,255,31,255,30,20,31,67,31,72,31,72,30,110,31,110,30,197,31,227,31,44,31,255,31,117,31,100,31,100,30,100,29,122,31,244,31,30,31,90,31,109,31,213,31,213,30,104,31,177,31,177,30,177,29,76,31,48,31,48,30,189,31,91,31,91,30,149,31,174,31,174,30,187,31,43,31,116,31,223,31,194,31,233,31,254,31,113,31,154,31,69,31,63,31,120,31,120,30,120,29,217,31,87,31,246,31,246,30,219,31,50,31,244,31,6,31,162,31,117,31,91,31,225,31,215,31,215,30,48,31,48,30,188,31,205,31,67,31,137,31,137,30,137,29,101,31,49,31,175,31,40,31,40,30,226,31,142,31,152,31,9,31,11,31,79,31,149,31,23,31,155,31,128,31,51,31,145,31,247,31,184,31,154,31,207,31,156,31,156,30,151,31,174,31,226,31,36,31,225,31,42,31,181,31,24,31,135,31,126,31,131,31,234,31,234,30,234,29,204,31,217,31,219,31,125,31,82,31,26,31,203,31,160,31,19,31,19,30,4,31,154,31,127,31,47,31,47,30,47,29,125,31,97,31,97,30,219,31,219,30,244,31,244,30,237,31,237,30,172,31,109,31,109,30,56,31,132,31,136,31,70,31,235,31,235,30,235,29,57,31,5,31,234,31,234,30,14,31,14,30,68,31,126,31,126,30,149,31,49,31,49,30,217,31,217,30,19,31,240,31,92,31,75,31,248,31,44,31,63,31,138,31,63,31,253,31,218,31,222,31,127,31,20,31,97,31,163,31,163,30,208,31,208,30,17,31,65,31,65,30,100,31,44,31,119,31,149,31,149,30,92,31,92,30,80,31,151,31,33,31,24,31,14,31,134,31,190,31,190,30,201,31,201,30,102,31,102,30,75,31,75,30,74,31,108,31,132,31,97,31,19,31,214,31,80,31,51,31,51,30,71,31,103,31,243,31,126,31,59,31,59,30,59,29,167,31,38,31,208,31,44,31,150,31,192,31,33,31,12,31,204,31,247,31,198,31,202,31,173,31,247,31,169,31,87,31,87,30,194,31,233,31,76,31,142,31,38,31,167,31,13,31,84,31,247,31,206,31,206,30,36,31,250,31,250,30,122,31,174,31,174,30,140,31,140,30,236,31,232,31,232,30,232,29,117,31,144,31,221,31,111,31,73,31,126,31,126,30,49,31,11,31,223,31,223,30,223,29,228,31,48,31,213,31,150,31,186,31,133,31,72,31,217,31,133,31,207,31,169,31,169,30,6,31,26,31,241,31,200,31,61,31,61,30,151,31,67,31,243,31,108,31,27,31,27,30,155,31,72,31,145,31,34,31,199,31,197,31,54,31,54,30,130,31,151,31,151,30,245,31,107,31,187,31,80,31,254,31,127,31,214,31,83,31,83,30,83,29,180,31,198,31,128,31,226,31,11,31,228,31,242,31,21,31,21,30,246,31,38,31,202,31,243,31,158,31,142,31,255,31,105,31,105,30,213,31,139,31,139,30,174,31,174,30,234,31,50,31,19,31,19,30,19,29,19,28,2,31,214,31,214,30,38,31,225,31,42,31,42,30,42,29,83,31,83,30,83,29,35,31,83,31,115,31,186,31,125,31,245,31,129,31,40,31,134,31,10,31,194,31);

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
