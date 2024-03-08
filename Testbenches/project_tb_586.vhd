-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_586 is
end project_tb_586;

architecture project_tb_arch_586 of project_tb_586 is
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

constant SCENARIO_LENGTH : integer := 279;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,91,0,90,0,80,0,22,0,29,0,213,0,62,0,182,0,55,0,9,0,237,0,0,0,181,0,230,0,225,0,104,0,250,0,162,0,190,0,0,0,24,0,0,0,57,0,61,0,178,0,0,0,204,0,0,0,0,0,21,0,15,0,80,0,14,0,0,0,0,0,70,0,0,0,95,0,194,0,0,0,98,0,0,0,6,0,204,0,123,0,59,0,78,0,0,0,127,0,112,0,0,0,0,0,0,0,0,0,219,0,61,0,0,0,210,0,43,0,215,0,230,0,74,0,36,0,196,0,236,0,160,0,166,0,204,0,0,0,76,0,250,0,0,0,6,0,169,0,0,0,0,0,0,0,0,0,232,0,145,0,55,0,120,0,223,0,110,0,233,0,111,0,10,0,145,0,12,0,195,0,18,0,125,0,140,0,104,0,34,0,195,0,22,0,2,0,77,0,0,0,111,0,182,0,197,0,210,0,0,0,27,0,232,0,7,0,180,0,118,0,248,0,0,0,0,0,0,0,153,0,0,0,63,0,47,0,186,0,51,0,0,0,0,0,0,0,45,0,62,0,0,0,0,0,18,0,13,0,30,0,254,0,70,0,156,0,39,0,53,0,0,0,209,0,16,0,161,0,65,0,140,0,51,0,200,0,120,0,129,0,224,0,77,0,7,0,218,0,0,0,8,0,107,0,0,0,168,0,0,0,228,0,37,0,46,0,15,0,125,0,0,0,30,0,60,0,237,0,235,0,0,0,40,0,210,0,0,0,184,0,87,0,25,0,93,0,148,0,122,0,0,0,252,0,236,0,76,0,238,0,167,0,0,0,50,0,12,0,173,0,57,0,0,0,43,0,15,0,144,0,14,0,3,0,35,0,84,0,0,0,78,0,126,0,206,0,76,0,81,0,67,0,233,0,218,0,98,0,60,0,246,0,184,0,104,0,175,0,40,0,36,0,34,0,125,0,0,0,157,0,2,0,0,0,0,0,46,0,82,0,162,0,196,0,188,0,15,0,167,0,0,0,39,0,145,0,73,0,0,0,255,0,154,0,223,0,16,0,225,0,0,0,131,0,184,0,97,0,177,0,159,0,231,0,211,0,167,0,88,0,129,0,51,0,209,0,0,0,122,0,15,0,230,0,0,0,133,0,77,0,140,0,22,0,95,0,222,0,5,0,71,0,33,0,0,0,49,0,43,0,181,0,227,0,0,0,48,0,0,0,95,0,25,0,225,0,50,0,32,0,109,0,237,0,0,0);
signal scenario_full  : scenario_type := (0,0,91,31,90,31,80,31,22,31,29,31,213,31,62,31,182,31,55,31,9,31,237,31,237,30,181,31,230,31,225,31,104,31,250,31,162,31,190,31,190,30,24,31,24,30,57,31,61,31,178,31,178,30,204,31,204,30,204,29,21,31,15,31,80,31,14,31,14,30,14,29,70,31,70,30,95,31,194,31,194,30,98,31,98,30,6,31,204,31,123,31,59,31,78,31,78,30,127,31,112,31,112,30,112,29,112,28,112,27,219,31,61,31,61,30,210,31,43,31,215,31,230,31,74,31,36,31,196,31,236,31,160,31,166,31,204,31,204,30,76,31,250,31,250,30,6,31,169,31,169,30,169,29,169,28,169,27,232,31,145,31,55,31,120,31,223,31,110,31,233,31,111,31,10,31,145,31,12,31,195,31,18,31,125,31,140,31,104,31,34,31,195,31,22,31,2,31,77,31,77,30,111,31,182,31,197,31,210,31,210,30,27,31,232,31,7,31,180,31,118,31,248,31,248,30,248,29,248,28,153,31,153,30,63,31,47,31,186,31,51,31,51,30,51,29,51,28,45,31,62,31,62,30,62,29,18,31,13,31,30,31,254,31,70,31,156,31,39,31,53,31,53,30,209,31,16,31,161,31,65,31,140,31,51,31,200,31,120,31,129,31,224,31,77,31,7,31,218,31,218,30,8,31,107,31,107,30,168,31,168,30,228,31,37,31,46,31,15,31,125,31,125,30,30,31,60,31,237,31,235,31,235,30,40,31,210,31,210,30,184,31,87,31,25,31,93,31,148,31,122,31,122,30,252,31,236,31,76,31,238,31,167,31,167,30,50,31,12,31,173,31,57,31,57,30,43,31,15,31,144,31,14,31,3,31,35,31,84,31,84,30,78,31,126,31,206,31,76,31,81,31,67,31,233,31,218,31,98,31,60,31,246,31,184,31,104,31,175,31,40,31,36,31,34,31,125,31,125,30,157,31,2,31,2,30,2,29,46,31,82,31,162,31,196,31,188,31,15,31,167,31,167,30,39,31,145,31,73,31,73,30,255,31,154,31,223,31,16,31,225,31,225,30,131,31,184,31,97,31,177,31,159,31,231,31,211,31,167,31,88,31,129,31,51,31,209,31,209,30,122,31,15,31,230,31,230,30,133,31,77,31,140,31,22,31,95,31,222,31,5,31,71,31,33,31,33,30,49,31,43,31,181,31,227,31,227,30,48,31,48,30,95,31,25,31,225,31,50,31,32,31,109,31,237,31,237,30);

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
