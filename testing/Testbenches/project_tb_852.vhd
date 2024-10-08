-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_852 is
end project_tb_852;

architecture project_tb_arch_852 of project_tb_852 is
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

constant SCENARIO_LENGTH : integer := 338;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (135,0,197,0,203,0,69,0,134,0,99,0,119,0,3,0,218,0,82,0,40,0,35,0,175,0,254,0,53,0,136,0,0,0,122,0,137,0,85,0,33,0,126,0,122,0,111,0,0,0,90,0,215,0,0,0,174,0,0,0,55,0,118,0,171,0,208,0,159,0,7,0,57,0,244,0,167,0,42,0,201,0,240,0,215,0,228,0,214,0,59,0,74,0,209,0,229,0,0,0,182,0,0,0,208,0,82,0,0,0,205,0,38,0,239,0,126,0,0,0,0,0,54,0,254,0,98,0,105,0,241,0,212,0,0,0,98,0,196,0,179,0,228,0,232,0,118,0,0,0,0,0,129,0,42,0,0,0,45,0,174,0,105,0,0,0,157,0,201,0,237,0,52,0,4,0,73,0,0,0,110,0,34,0,159,0,110,0,90,0,119,0,0,0,106,0,132,0,0,0,147,0,192,0,46,0,0,0,169,0,0,0,48,0,52,0,191,0,0,0,0,0,0,0,166,0,186,0,121,0,64,0,0,0,224,0,245,0,193,0,110,0,23,0,191,0,124,0,0,0,225,0,254,0,176,0,136,0,115,0,35,0,216,0,203,0,13,0,58,0,244,0,0,0,0,0,168,0,77,0,49,0,164,0,160,0,5,0,66,0,250,0,0,0,198,0,237,0,120,0,252,0,198,0,44,0,184,0,75,0,245,0,64,0,19,0,212,0,154,0,191,0,128,0,131,0,165,0,0,0,0,0,0,0,143,0,230,0,191,0,184,0,67,0,208,0,0,0,120,0,37,0,251,0,27,0,205,0,8,0,212,0,0,0,0,0,0,0,212,0,100,0,0,0,57,0,21,0,91,0,246,0,48,0,44,0,5,0,206,0,68,0,0,0,176,0,0,0,40,0,127,0,194,0,206,0,42,0,110,0,23,0,128,0,255,0,0,0,168,0,203,0,0,0,198,0,34,0,205,0,41,0,224,0,60,0,183,0,49,0,146,0,243,0,119,0,198,0,123,0,139,0,190,0,0,0,0,0,66,0,251,0,51,0,0,0,245,0,58,0,183,0,242,0,81,0,84,0,118,0,12,0,203,0,216,0,126,0,0,0,50,0,80,0,80,0,83,0,93,0,31,0,212,0,173,0,8,0,0,0,197,0,0,0,198,0,0,0,171,0,128,0,9,0,0,0,55,0,36,0,157,0,25,0,199,0,127,0,231,0,0,0,0,0,124,0,25,0,45,0,0,0,246,0,0,0,8,0,0,0,182,0,0,0,0,0,5,0,154,0,131,0,120,0,227,0,149,0,90,0,102,0,66,0,153,0,69,0,82,0,0,0,68,0,176,0,14,0,143,0,0,0,229,0,0,0,141,0,41,0,0,0,121,0,0,0,66,0,65,0,0,0,167,0,126,0,58,0,0,0,145,0,187,0,124,0,0,0,33,0,236,0,0,0,31,0,190,0,162,0,54,0,0,0,142,0,245,0,159,0,151,0,165,0,0,0,186,0,0,0,0,0,155,0,0,0);
signal scenario_full  : scenario_type := (135,31,197,31,203,31,69,31,134,31,99,31,119,31,3,31,218,31,82,31,40,31,35,31,175,31,254,31,53,31,136,31,136,30,122,31,137,31,85,31,33,31,126,31,122,31,111,31,111,30,90,31,215,31,215,30,174,31,174,30,55,31,118,31,171,31,208,31,159,31,7,31,57,31,244,31,167,31,42,31,201,31,240,31,215,31,228,31,214,31,59,31,74,31,209,31,229,31,229,30,182,31,182,30,208,31,82,31,82,30,205,31,38,31,239,31,126,31,126,30,126,29,54,31,254,31,98,31,105,31,241,31,212,31,212,30,98,31,196,31,179,31,228,31,232,31,118,31,118,30,118,29,129,31,42,31,42,30,45,31,174,31,105,31,105,30,157,31,201,31,237,31,52,31,4,31,73,31,73,30,110,31,34,31,159,31,110,31,90,31,119,31,119,30,106,31,132,31,132,30,147,31,192,31,46,31,46,30,169,31,169,30,48,31,52,31,191,31,191,30,191,29,191,28,166,31,186,31,121,31,64,31,64,30,224,31,245,31,193,31,110,31,23,31,191,31,124,31,124,30,225,31,254,31,176,31,136,31,115,31,35,31,216,31,203,31,13,31,58,31,244,31,244,30,244,29,168,31,77,31,49,31,164,31,160,31,5,31,66,31,250,31,250,30,198,31,237,31,120,31,252,31,198,31,44,31,184,31,75,31,245,31,64,31,19,31,212,31,154,31,191,31,128,31,131,31,165,31,165,30,165,29,165,28,143,31,230,31,191,31,184,31,67,31,208,31,208,30,120,31,37,31,251,31,27,31,205,31,8,31,212,31,212,30,212,29,212,28,212,31,100,31,100,30,57,31,21,31,91,31,246,31,48,31,44,31,5,31,206,31,68,31,68,30,176,31,176,30,40,31,127,31,194,31,206,31,42,31,110,31,23,31,128,31,255,31,255,30,168,31,203,31,203,30,198,31,34,31,205,31,41,31,224,31,60,31,183,31,49,31,146,31,243,31,119,31,198,31,123,31,139,31,190,31,190,30,190,29,66,31,251,31,51,31,51,30,245,31,58,31,183,31,242,31,81,31,84,31,118,31,12,31,203,31,216,31,126,31,126,30,50,31,80,31,80,31,83,31,93,31,31,31,212,31,173,31,8,31,8,30,197,31,197,30,198,31,198,30,171,31,128,31,9,31,9,30,55,31,36,31,157,31,25,31,199,31,127,31,231,31,231,30,231,29,124,31,25,31,45,31,45,30,246,31,246,30,8,31,8,30,182,31,182,30,182,29,5,31,154,31,131,31,120,31,227,31,149,31,90,31,102,31,66,31,153,31,69,31,82,31,82,30,68,31,176,31,14,31,143,31,143,30,229,31,229,30,141,31,41,31,41,30,121,31,121,30,66,31,65,31,65,30,167,31,126,31,58,31,58,30,145,31,187,31,124,31,124,30,33,31,236,31,236,30,31,31,190,31,162,31,54,31,54,30,142,31,245,31,159,31,151,31,165,31,165,30,186,31,186,30,186,29,155,31,155,30);

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
