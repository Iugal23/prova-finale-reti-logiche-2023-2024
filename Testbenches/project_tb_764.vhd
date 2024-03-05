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

constant SCENARIO_LENGTH : integer := 342;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (162,0,172,0,182,0,0,0,204,0,226,0,0,0,0,0,52,0,220,0,49,0,134,0,4,0,212,0,124,0,0,0,117,0,0,0,0,0,169,0,201,0,0,0,34,0,77,0,137,0,2,0,61,0,104,0,195,0,11,0,218,0,241,0,227,0,69,0,0,0,250,0,49,0,0,0,212,0,101,0,109,0,193,0,233,0,39,0,208,0,0,0,213,0,15,0,184,0,0,0,0,0,205,0,0,0,1,0,0,0,0,0,202,0,134,0,102,0,177,0,171,0,0,0,237,0,71,0,31,0,238,0,197,0,60,0,149,0,0,0,30,0,103,0,36,0,53,0,195,0,87,0,253,0,0,0,17,0,128,0,0,0,252,0,118,0,0,0,0,0,193,0,203,0,42,0,0,0,181,0,176,0,208,0,86,0,254,0,68,0,60,0,173,0,213,0,0,0,86,0,182,0,40,0,255,0,0,0,32,0,16,0,132,0,80,0,19,0,153,0,238,0,0,0,0,0,139,0,213,0,240,0,43,0,148,0,37,0,206,0,0,0,165,0,0,0,39,0,181,0,0,0,140,0,147,0,213,0,128,0,50,0,0,0,3,0,5,0,213,0,88,0,106,0,0,0,0,0,35,0,175,0,78,0,198,0,88,0,17,0,149,0,142,0,238,0,0,0,6,0,74,0,117,0,164,0,128,0,77,0,6,0,186,0,188,0,15,0,217,0,231,0,165,0,0,0,69,0,83,0,239,0,157,0,0,0,0,0,91,0,0,0,0,0,18,0,27,0,156,0,0,0,34,0,157,0,149,0,118,0,153,0,42,0,189,0,126,0,42,0,242,0,218,0,203,0,227,0,117,0,7,0,14,0,218,0,0,0,0,0,244,0,27,0,65,0,238,0,90,0,66,0,211,0,0,0,0,0,190,0,70,0,229,0,0,0,225,0,28,0,199,0,0,0,239,0,0,0,0,0,124,0,75,0,175,0,7,0,103,0,40,0,63,0,30,0,0,0,109,0,207,0,213,0,94,0,157,0,33,0,10,0,16,0,0,0,73,0,184,0,172,0,194,0,0,0,77,0,0,0,0,0,133,0,0,0,181,0,0,0,192,0,0,0,214,0,186,0,8,0,115,0,52,0,0,0,190,0,0,0,77,0,43,0,42,0,126,0,253,0,96,0,50,0,89,0,225,0,179,0,95,0,181,0,0,0,192,0,232,0,194,0,0,0,127,0,182,0,207,0,169,0,5,0,60,0,246,0,142,0,58,0,10,0,77,0,126,0,196,0,229,0,12,0,220,0,127,0,172,0,0,0,0,0,161,0,219,0,99,0,20,0,234,0,72,0,233,0,0,0,230,0,0,0,0,0,188,0,195,0,0,0,23,0,0,0,102,0,190,0,139,0,0,0,40,0,251,0,226,0,204,0,105,0,121,0,119,0,117,0,17,0,0,0,133,0,86,0,0,0,8,0,190,0,64,0,74,0,0,0,226,0,52,0,231,0,161,0,159,0,44,0,0,0,70,0,255,0,0,0,201,0,177,0);
signal scenario_full  : scenario_type := (162,31,172,31,182,31,182,30,204,31,226,31,226,30,226,29,52,31,220,31,49,31,134,31,4,31,212,31,124,31,124,30,117,31,117,30,117,29,169,31,201,31,201,30,34,31,77,31,137,31,2,31,61,31,104,31,195,31,11,31,218,31,241,31,227,31,69,31,69,30,250,31,49,31,49,30,212,31,101,31,109,31,193,31,233,31,39,31,208,31,208,30,213,31,15,31,184,31,184,30,184,29,205,31,205,30,1,31,1,30,1,29,202,31,134,31,102,31,177,31,171,31,171,30,237,31,71,31,31,31,238,31,197,31,60,31,149,31,149,30,30,31,103,31,36,31,53,31,195,31,87,31,253,31,253,30,17,31,128,31,128,30,252,31,118,31,118,30,118,29,193,31,203,31,42,31,42,30,181,31,176,31,208,31,86,31,254,31,68,31,60,31,173,31,213,31,213,30,86,31,182,31,40,31,255,31,255,30,32,31,16,31,132,31,80,31,19,31,153,31,238,31,238,30,238,29,139,31,213,31,240,31,43,31,148,31,37,31,206,31,206,30,165,31,165,30,39,31,181,31,181,30,140,31,147,31,213,31,128,31,50,31,50,30,3,31,5,31,213,31,88,31,106,31,106,30,106,29,35,31,175,31,78,31,198,31,88,31,17,31,149,31,142,31,238,31,238,30,6,31,74,31,117,31,164,31,128,31,77,31,6,31,186,31,188,31,15,31,217,31,231,31,165,31,165,30,69,31,83,31,239,31,157,31,157,30,157,29,91,31,91,30,91,29,18,31,27,31,156,31,156,30,34,31,157,31,149,31,118,31,153,31,42,31,189,31,126,31,42,31,242,31,218,31,203,31,227,31,117,31,7,31,14,31,218,31,218,30,218,29,244,31,27,31,65,31,238,31,90,31,66,31,211,31,211,30,211,29,190,31,70,31,229,31,229,30,225,31,28,31,199,31,199,30,239,31,239,30,239,29,124,31,75,31,175,31,7,31,103,31,40,31,63,31,30,31,30,30,109,31,207,31,213,31,94,31,157,31,33,31,10,31,16,31,16,30,73,31,184,31,172,31,194,31,194,30,77,31,77,30,77,29,133,31,133,30,181,31,181,30,192,31,192,30,214,31,186,31,8,31,115,31,52,31,52,30,190,31,190,30,77,31,43,31,42,31,126,31,253,31,96,31,50,31,89,31,225,31,179,31,95,31,181,31,181,30,192,31,232,31,194,31,194,30,127,31,182,31,207,31,169,31,5,31,60,31,246,31,142,31,58,31,10,31,77,31,126,31,196,31,229,31,12,31,220,31,127,31,172,31,172,30,172,29,161,31,219,31,99,31,20,31,234,31,72,31,233,31,233,30,230,31,230,30,230,29,188,31,195,31,195,30,23,31,23,30,102,31,190,31,139,31,139,30,40,31,251,31,226,31,204,31,105,31,121,31,119,31,117,31,17,31,17,30,133,31,86,31,86,30,8,31,190,31,64,31,74,31,74,30,226,31,52,31,231,31,161,31,159,31,44,31,44,30,70,31,255,31,255,30,201,31,177,31);

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
