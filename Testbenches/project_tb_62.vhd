-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_62 is
end project_tb_62;

architecture project_tb_arch_62 of project_tb_62 is
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

constant SCENARIO_LENGTH : integer := 256;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (109,0,0,0,0,0,168,0,40,0,231,0,231,0,0,0,0,0,0,0,170,0,1,0,35,0,0,0,143,0,0,0,170,0,134,0,0,0,212,0,227,0,205,0,22,0,182,0,149,0,83,0,0,0,253,0,141,0,0,0,6,0,248,0,166,0,154,0,171,0,17,0,69,0,138,0,61,0,223,0,97,0,118,0,132,0,221,0,183,0,7,0,232,0,0,0,0,0,8,0,88,0,70,0,212,0,103,0,59,0,127,0,181,0,0,0,25,0,128,0,0,0,0,0,246,0,243,0,194,0,105,0,0,0,50,0,93,0,101,0,167,0,85,0,60,0,212,0,239,0,0,0,130,0,240,0,196,0,0,0,115,0,245,0,89,0,173,0,232,0,225,0,70,0,94,0,106,0,112,0,55,0,155,0,0,0,132,0,31,0,225,0,0,0,200,0,244,0,213,0,0,0,204,0,0,0,177,0,0,0,172,0,84,0,57,0,196,0,0,0,117,0,198,0,0,0,96,0,0,0,0,0,76,0,0,0,122,0,126,0,49,0,0,0,0,0,233,0,203,0,27,0,0,0,0,0,0,0,63,0,202,0,59,0,0,0,197,0,54,0,195,0,117,0,251,0,127,0,163,0,0,0,138,0,134,0,97,0,235,0,106,0,68,0,44,0,0,0,223,0,4,0,227,0,0,0,0,0,59,0,61,0,18,0,208,0,190,0,0,0,240,0,112,0,140,0,16,0,113,0,48,0,9,0,148,0,17,0,131,0,8,0,2,0,0,0,68,0,229,0,164,0,235,0,0,0,3,0,222,0,0,0,0,0,178,0,207,0,0,0,84,0,0,0,139,0,155,0,0,0,29,0,152,0,222,0,153,0,0,0,155,0,156,0,160,0,113,0,42,0,0,0,164,0,203,0,97,0,0,0,0,0,225,0,94,0,77,0,176,0,177,0,204,0,209,0,0,0,54,0,10,0,226,0,23,0,221,0,106,0,127,0,201,0,71,0,221,0,64,0,135,0,159,0,204,0,70,0,0,0,0,0,57,0,154,0,10,0,70,0,0,0,0,0,119,0,243,0,81,0,215,0,51,0,107,0,0,0,224,0,88,0,185,0,227,0,130,0,0,0,188,0,18,0,115,0,0,0,0,0,21,0);
signal scenario_full  : scenario_type := (109,31,109,30,109,29,168,31,40,31,231,31,231,31,231,30,231,29,231,28,170,31,1,31,35,31,35,30,143,31,143,30,170,31,134,31,134,30,212,31,227,31,205,31,22,31,182,31,149,31,83,31,83,30,253,31,141,31,141,30,6,31,248,31,166,31,154,31,171,31,17,31,69,31,138,31,61,31,223,31,97,31,118,31,132,31,221,31,183,31,7,31,232,31,232,30,232,29,8,31,88,31,70,31,212,31,103,31,59,31,127,31,181,31,181,30,25,31,128,31,128,30,128,29,246,31,243,31,194,31,105,31,105,30,50,31,93,31,101,31,167,31,85,31,60,31,212,31,239,31,239,30,130,31,240,31,196,31,196,30,115,31,245,31,89,31,173,31,232,31,225,31,70,31,94,31,106,31,112,31,55,31,155,31,155,30,132,31,31,31,225,31,225,30,200,31,244,31,213,31,213,30,204,31,204,30,177,31,177,30,172,31,84,31,57,31,196,31,196,30,117,31,198,31,198,30,96,31,96,30,96,29,76,31,76,30,122,31,126,31,49,31,49,30,49,29,233,31,203,31,27,31,27,30,27,29,27,28,63,31,202,31,59,31,59,30,197,31,54,31,195,31,117,31,251,31,127,31,163,31,163,30,138,31,134,31,97,31,235,31,106,31,68,31,44,31,44,30,223,31,4,31,227,31,227,30,227,29,59,31,61,31,18,31,208,31,190,31,190,30,240,31,112,31,140,31,16,31,113,31,48,31,9,31,148,31,17,31,131,31,8,31,2,31,2,30,68,31,229,31,164,31,235,31,235,30,3,31,222,31,222,30,222,29,178,31,207,31,207,30,84,31,84,30,139,31,155,31,155,30,29,31,152,31,222,31,153,31,153,30,155,31,156,31,160,31,113,31,42,31,42,30,164,31,203,31,97,31,97,30,97,29,225,31,94,31,77,31,176,31,177,31,204,31,209,31,209,30,54,31,10,31,226,31,23,31,221,31,106,31,127,31,201,31,71,31,221,31,64,31,135,31,159,31,204,31,70,31,70,30,70,29,57,31,154,31,10,31,70,31,70,30,70,29,119,31,243,31,81,31,215,31,51,31,107,31,107,30,224,31,88,31,185,31,227,31,130,31,130,30,188,31,18,31,115,31,115,30,115,29,21,31);

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
