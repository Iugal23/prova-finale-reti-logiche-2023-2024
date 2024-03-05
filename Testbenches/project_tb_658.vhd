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

constant SCENARIO_LENGTH : integer := 297;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (28,0,0,0,0,0,27,0,190,0,145,0,0,0,219,0,79,0,236,0,0,0,234,0,104,0,149,0,0,0,198,0,187,0,187,0,0,0,152,0,245,0,220,0,0,0,123,0,159,0,185,0,173,0,118,0,224,0,60,0,185,0,0,0,113,0,0,0,172,0,235,0,0,0,171,0,0,0,131,0,106,0,35,0,16,0,105,0,5,0,248,0,17,0,78,0,61,0,0,0,145,0,145,0,115,0,17,0,88,0,0,0,153,0,59,0,60,0,195,0,108,0,120,0,174,0,215,0,0,0,242,0,103,0,128,0,23,0,124,0,238,0,51,0,105,0,20,0,119,0,252,0,194,0,0,0,43,0,0,0,113,0,190,0,12,0,58,0,170,0,60,0,178,0,63,0,171,0,138,0,150,0,97,0,0,0,0,0,16,0,27,0,130,0,89,0,46,0,50,0,9,0,44,0,255,0,20,0,42,0,137,0,0,0,196,0,0,0,124,0,155,0,100,0,180,0,0,0,145,0,204,0,0,0,121,0,219,0,0,0,83,0,137,0,90,0,60,0,147,0,118,0,63,0,210,0,0,0,0,0,0,0,119,0,0,0,103,0,0,0,253,0,238,0,203,0,173,0,32,0,220,0,0,0,69,0,144,0,18,0,86,0,198,0,239,0,0,0,235,0,0,0,196,0,21,0,229,0,192,0,0,0,196,0,92,0,63,0,52,0,197,0,67,0,112,0,132,0,4,0,19,0,63,0,173,0,136,0,116,0,26,0,211,0,102,0,244,0,62,0,145,0,4,0,130,0,6,0,165,0,145,0,115,0,0,0,171,0,87,0,194,0,25,0,103,0,155,0,126,0,0,0,150,0,4,0,157,0,0,0,0,0,188,0,245,0,0,0,12,0,7,0,126,0,40,0,122,0,154,0,206,0,146,0,0,0,125,0,113,0,151,0,240,0,90,0,83,0,0,0,98,0,91,0,99,0,92,0,179,0,46,0,0,0,109,0,0,0,38,0,218,0,151,0,56,0,210,0,234,0,28,0,104,0,161,0,117,0,24,0,242,0,110,0,235,0,0,0,213,0,126,0,25,0,231,0,0,0,246,0,14,0,208,0,112,0,0,0,0,0,60,0,68,0,131,0,0,0,141,0,96,0,159,0,67,0,58,0,116,0,114,0,0,0,0,0,145,0,155,0,247,0,203,0,15,0,245,0,112,0,0,0,0,0,161,0,220,0,32,0,167,0,0,0,37,0,0,0,251,0,191,0,0,0,0,0,149,0,233,0,223,0,9,0,0,0,44,0,170,0,0,0,64,0,253,0,0,0,41,0,34,0,244,0);
signal scenario_full  : scenario_type := (28,31,28,30,28,29,27,31,190,31,145,31,145,30,219,31,79,31,236,31,236,30,234,31,104,31,149,31,149,30,198,31,187,31,187,31,187,30,152,31,245,31,220,31,220,30,123,31,159,31,185,31,173,31,118,31,224,31,60,31,185,31,185,30,113,31,113,30,172,31,235,31,235,30,171,31,171,30,131,31,106,31,35,31,16,31,105,31,5,31,248,31,17,31,78,31,61,31,61,30,145,31,145,31,115,31,17,31,88,31,88,30,153,31,59,31,60,31,195,31,108,31,120,31,174,31,215,31,215,30,242,31,103,31,128,31,23,31,124,31,238,31,51,31,105,31,20,31,119,31,252,31,194,31,194,30,43,31,43,30,113,31,190,31,12,31,58,31,170,31,60,31,178,31,63,31,171,31,138,31,150,31,97,31,97,30,97,29,16,31,27,31,130,31,89,31,46,31,50,31,9,31,44,31,255,31,20,31,42,31,137,31,137,30,196,31,196,30,124,31,155,31,100,31,180,31,180,30,145,31,204,31,204,30,121,31,219,31,219,30,83,31,137,31,90,31,60,31,147,31,118,31,63,31,210,31,210,30,210,29,210,28,119,31,119,30,103,31,103,30,253,31,238,31,203,31,173,31,32,31,220,31,220,30,69,31,144,31,18,31,86,31,198,31,239,31,239,30,235,31,235,30,196,31,21,31,229,31,192,31,192,30,196,31,92,31,63,31,52,31,197,31,67,31,112,31,132,31,4,31,19,31,63,31,173,31,136,31,116,31,26,31,211,31,102,31,244,31,62,31,145,31,4,31,130,31,6,31,165,31,145,31,115,31,115,30,171,31,87,31,194,31,25,31,103,31,155,31,126,31,126,30,150,31,4,31,157,31,157,30,157,29,188,31,245,31,245,30,12,31,7,31,126,31,40,31,122,31,154,31,206,31,146,31,146,30,125,31,113,31,151,31,240,31,90,31,83,31,83,30,98,31,91,31,99,31,92,31,179,31,46,31,46,30,109,31,109,30,38,31,218,31,151,31,56,31,210,31,234,31,28,31,104,31,161,31,117,31,24,31,242,31,110,31,235,31,235,30,213,31,126,31,25,31,231,31,231,30,246,31,14,31,208,31,112,31,112,30,112,29,60,31,68,31,131,31,131,30,141,31,96,31,159,31,67,31,58,31,116,31,114,31,114,30,114,29,145,31,155,31,247,31,203,31,15,31,245,31,112,31,112,30,112,29,161,31,220,31,32,31,167,31,167,30,37,31,37,30,251,31,191,31,191,30,191,29,149,31,233,31,223,31,9,31,9,30,44,31,170,31,170,30,64,31,253,31,253,30,41,31,34,31,244,31);

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
